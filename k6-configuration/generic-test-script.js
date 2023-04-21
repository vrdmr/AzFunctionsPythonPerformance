import { check } from "k6";
import { Rate } from "k6/metrics";
import http from "k6/http";

// Invoke using : RATE=300 DURATION=300s HOSTNAME=test-memory-usage-python.azurewebsites.net PROTOCOL=https FUNCTION=httptrigger1 NUM_USERS=900  k6 run /Users/varadmeru/work/microsoft/azure_functions/AzFunctionsPythonPerformance/k6-configuration/generic-test-script.js

// These are still very much WIP and untested, but you can use them as is or write your own!
import { textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';

const data = { name: 'OGF_Testing' };
const headers = { 'Content-Type': 'application/json' };

var FUNCTION = __ENV.FUNCTION;
var HOSTNAME = __ENV.HOSTNAME || 'localhost';
var PORT     = __ENV.PORT || '';
var PROTOCOL = __ENV.PROTOCOL || (PORT === '80' || PORT === '7071'  ? 'http' : 'https');
var NUM_USERS = __ENV.NUM_USERS || 100;
var TEST_TIME = __ENV.TEST_TIME || "10s";
var DURATION = __ENV.DURATION || "1m";
var RAMPUP_TIME = __ENV.RAMPUP_TIME || "10s";
var RATE = __ENV.RATE || 500;

if (PORT == '') {
    var URL = `${PROTOCOL}://${HOSTNAME}/api/${FUNCTION}`
} else {
    var URL = `${PROTOCOL}://${HOSTNAME}:${PORT}/api/${FUNCTION}`
}

// A custom metric to track failure rates
var failureRate = new Rate("check_failure_rate");

// Options
// export let options = {
//     stages: [
//         { target: NUM_USERS, duration: RAMPUP_TIME },
//         { target: NUM_USERS, duration: TEST_TIME },
//         { target: 0, duration: RAMPUP_TIME }
//     ],
//     thresholds: {
//         // We want the 95th percentile of all HTTP request durations to be less than 500ms
//         "http_req_duration": ["p(50)<5000"],
//         // Thresholds based on the custom metric we defined and use to track application failures
//         "check_failure_rate": [
//             // Global failure rate should be less than 1%
//             //"rate<0.11",
//             // Abort the test early if it climbs over 5%
//             //{ threshold: "rate<=0.05", abortOnFail: true },
//         ],
//     },
// };

export const options = {
    scenarios: {
      constant_request_rate: {
        executor: 'constant-arrival-rate',
        rate: RATE,
        timeUnit: '1s',
        duration: DURATION,
        preAllocatedVUs: 10,
        maxVUs: NUM_USERS,
      },
    },
  };

// Main function
export default function () {
    let response = http.get(URL, JSON.stringify(data), { headers: headers });

    // check() returns false if any of the specified conditions fail
    let checkRes = check(response, {
        "status is 200": (r) => r.status === 200,
        // "content is present": (r) => r.body.indexOf("This HTTP triggered function executed successfully") !== -1,
    });

    // We reverse the check() result since we want to count the failures
    failureRate.add(!checkRes);
}


export function handleSummary(data) {
    console.log('Preparing the end-of-test summary...');

    return {
      'stdout': textSummary(data, { indent: ' ', enableColors: true }), // Show the text summary to stdout...
      'summary.json' : JSON.stringify(data, null, 4), // and a JSON with all the details...
      // And any other JS transformation of the data you can think of,
      // you can write your own JS helpers to transform the summary data however you like!
    };
  }
