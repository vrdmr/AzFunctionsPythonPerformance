import logging
import json
import string
import time
import random
import gc

import azure.functions as func
import numpy

system_logger = logging.getLogger('azure_functions_worker')
user_logger = logging.getLogger('customer_logger')

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        type_ = req.params.get('type')
        gc_ = req.params.get('gc')
        repeat = int(req.params.get('repeat'))
        size = int(req.params.get('size'))

        assert(type_ in ('system', 'user'))
        assert(gc_ in ('true', 'false'))
    except:
        return generate_help(req)

    if gc_ == 'false':
        gc.disable()
        gc.collect()

    time_elapseds = []
    for _ in range(repeat):
        content = generate_logging_content(int(size))

        # Start timer after random string generation
        start_time = time.time_ns()
        if type_ == 'system':
            system_logger.info(content)
        elif type_ == 'user':
            user_logger.info(content)
        # End timer and calculate string generation
        end_time = time.time_ns()

        time_elapseds.append(end_time - start_time)

    if gc_ == 'false':
        gc.collect()
        gc.enable()

    result = {
        'logging_type': type_,
        'repeated_times': repeat,
        'message_size': size,
        'ns_per_message': {
            'avg': '{:.2f}'.format(sum(time_elapseds) / repeat),
            'max': '{:.2f}'.format(max(time_elapseds)),
            'min': '{:.2f}'.format(min(time_elapseds)),
            '99.99%': '{:.2f}'.format(numpy.percentile(time_elapseds, 99.99)),
            '99.90%': '{:.2f}'.format(numpy.percentile(time_elapseds, 99.9)),
            '99.00%': '{:.2f}'.format(numpy.percentile(time_elapseds, 99)),
            '90.00%': '{:.2f}'.format(numpy.percentile(time_elapseds, 90)),
            '75.00%': '{:.2f}'.format(numpy.percentile(time_elapseds, 75)),
            '50.00%': '{:.2f}'.format(numpy.percentile(time_elapseds, 50)),
        },
        'ns_per_char': {
            'avg': '{:.2f}'.format(sum(time_elapseds) / size / repeat),
            'max': '{:.2f}'.format(max(time_elapseds) / size),
            'min': '{:.2f}'.format(min(time_elapseds) / size),
            '99.99%': '{:.2f}'.format(numpy.percentile(time_elapseds, 99.99) / size),
            '99.90%': '{:.2f}'.format(numpy.percentile(time_elapseds, 99.9) / size),
            '99.00%': '{:.2f}'.format(numpy.percentile(time_elapseds, 99) / size),
            '90.00%': '{:.2f}'.format(numpy.percentile(time_elapseds, 90) / size),
            '75.00%': '{:.2f}'.format(numpy.percentile(time_elapseds, 75) / size),
            '50.00%': '{:.2f}'.format(numpy.percentile(time_elapseds, 50) / size),
        }
    }

    if repeat >= 10:
        result['top_10_results'] = sorted(time_elapseds, reverse=True)[:10]
        result['bot_10_results'] = sorted(time_elapseds, reverse=False)[:10]

    return func.HttpResponse(
        json.dumps(result),
        status_code=200
    )

def generate_help(req: func.HttpRequest) -> func.HttpResponse:
    return func.HttpResponse(
        status_code=200,
        mimetype='application/json',
        body=json.dumps({
            'instruction': {
                'usage': '/api/SyncLogging?type=system&repeat=100&size=1000&gc=false'
            },
            'required_query_param': {
                '?type=': 'Define where the logs should be sent to. (system, user)',
                '?gc=': 'Define whether the automatic GC collection should be enabled. (true, false)',
                '?repeat=': 'How many times this operation will be repeated. (example: 42, recommend: <= 1000)',
                '?size=': 'How many bytes are sent through the logging system. (example: 36, recommend: <= 1000000 (no console print))',
            }
        })
    )

def generate_logging_content(size: int) -> bytes:
    return ''.join(random.choice(string.ascii_letters) for _ in range(size))
