#!/usr/bin/env python

import json
import pandas as pd
import os
import re


PYTHON_USED = "3.7"


class ProcessData(object):
    def __init__(self, k6runs_dir):
        self.matchr = re.compile(r"pywinder-(nologging-)?wrk([0-9]*)-stp-([0-9none]*)")
        self.k6runs_dir = k6runs_dir

    @staticmethod
    def _sync_tp_count(plan):
        """
        # Check the default - https://docs.python.org/3/library/concurrent.futures.html?highlight=threadpool%20executor#concurrent.futures.ThreadPoolExecutor
        # For 3.5  os.cpu_count() * 5
        # For 3.6  os.cpu_count() * 5
        # For 3.7  os.cpu_count() * 5
        # For 3.8  min(32, os.cpu_count() + 4)
        """
        if PYTHON_USED == "3.7" or PYTHON_USED == "3.6" or PYTHON_USED == "3.5":
            if plan == "consumption":
                return 1 * 5
            elif plan == "ep1":
                return 1 * 5
            elif plan == "ep2":
                return 2 * 5
            elif plan == "ep3":
                return 4 * 5
        else:
            if plan == "consumption":
                return 1 + 4
            elif plan == "ep1":
                return 1 + 4
            elif plan == "ep2":
                return 2 + 4
            elif plan == "ep3":
                return 4 + 4


    def process_path_for_scenario_and_infra(self, path):
        path_list = path.split('-')
        image = '-'.join([i if not i.endswith(".json") else "" for i in path_list[2:]]).strip('-')
        groups = self.matchr.match(image)
        

        return {
            "scenario": path_list[0],
            "plan": path_list[1],
            "worker": groups[2],
            "syncthreadpoolsize": self._sync_tp_count(path_list[1]) if groups[3] == "none" else groups[3],
            "image": image,
            "notes": "no logging in _handle__invocation_request" if "nologging" in image else None
        }

    def process_k6_json(self, path=None):
        try:
            with open(os.path.join(self.k6runs_dir, path)) as f:
                data_for_csv = self.process_path_for_scenario_and_infra(path)

                experiment_run = pd.read_json(f)
                experiment_metrics = experiment_run["metrics"]

                data_for_csv["http_reqs_count"] =  experiment_metrics["http_reqs"]["count"]
                data_for_csv["http_reqs_rate"] =   experiment_metrics["http_reqs"]["rate"]

                data_for_csv["checks_passes"] =  experiment_metrics["checks"]["passes"]
                data_for_csv["checks_fails"] =  experiment_metrics["checks"]["fails"]

                data_for_csv["iterations_count"] = experiment_metrics["iterations"]["count"]
                data_for_csv["iterations_rate"] =  experiment_metrics["iterations"]["rate"]

                data_for_csv["virtual_users_max"] =  experiment_metrics["vus"]["max"]
                data_for_csv["virtual_users_min"] =  experiment_metrics["vus"]["min"]

                data_for_csv["virtual_users_max_max"] =  experiment_metrics["vus"]["max"]
                data_for_csv["virtual_users_max_min"] =  experiment_metrics["vus_max"]["min"]

                data_for_csv["http_req_blocked_avg"] =  experiment_metrics["http_req_blocked"]["avg"]
                data_for_csv["http_req_blocked_max"] =  experiment_metrics["http_req_blocked"]["max"]
                data_for_csv["http_req_blocked_med"] =  experiment_metrics["http_req_blocked"]["med"]
                data_for_csv["http_req_blocked_min"] =  experiment_metrics["http_req_blocked"]["min"]
                data_for_csv["http_req_blocked_p90"] =  experiment_metrics["http_req_blocked"]["p(90)"]
                data_for_csv["http_req_blocked_p95"] =  experiment_metrics["http_req_blocked"]["p(95)"]

                data_for_csv["http_req_connecting_avg"] =  experiment_metrics["http_req_connecting"]["avg"]
                data_for_csv["http_req_connecting_max"] =  experiment_metrics["http_req_connecting"]["max"]
                data_for_csv["http_req_connecting_med"] =  experiment_metrics["http_req_connecting"]["med"]
                data_for_csv["http_req_connecting_min"] =  experiment_metrics["http_req_connecting"]["min"]
                data_for_csv["http_req_connecting_p90"] =  experiment_metrics["http_req_connecting"]["p(90)"]
                data_for_csv["http_req_connecting_p95"] =  experiment_metrics["http_req_connecting"]["p(95)"]

                data_for_csv["http_req_duration_avg"] =  experiment_metrics["http_req_duration"]["avg"]
                data_for_csv["http_req_duration_max"] =  experiment_metrics["http_req_duration"]["max"]
                data_for_csv["http_req_duration_med"] =  experiment_metrics["http_req_duration"]["med"]
                data_for_csv["http_req_duration_min"] =  experiment_metrics["http_req_duration"]["min"]
                data_for_csv["http_req_duration_p90"] =  experiment_metrics["http_req_duration"]["p(90)"]
                data_for_csv["http_req_duration_p95"] =  experiment_metrics["http_req_duration"]["p(95)"]

                data_for_csv["http_req_receiving_avg"] =  experiment_metrics["http_req_receiving"]["avg"]
                data_for_csv["http_req_receiving_max"] =  experiment_metrics["http_req_receiving"]["max"]
                data_for_csv["http_req_receiving_med"] =  experiment_metrics["http_req_receiving"]["med"]
                data_for_csv["http_req_receiving_min"] =  experiment_metrics["http_req_receiving"]["min"]
                data_for_csv["http_req_receiving_p90"] =  experiment_metrics["http_req_receiving"]["p(90)"]
                data_for_csv["http_req_receiving_p95"] =  experiment_metrics["http_req_receiving"]["p(95)"]

                data_for_csv["http_req_sending_avg"] =  experiment_metrics["http_req_sending"]["avg"]
                data_for_csv["http_req_sending_max"] =  experiment_metrics["http_req_sending"]["max"]
                data_for_csv["http_req_sending_med"] =  experiment_metrics["http_req_sending"]["med"]
                data_for_csv["http_req_sending_min"] =  experiment_metrics["http_req_sending"]["min"]
                data_for_csv["http_req_sending_p90"] =  experiment_metrics["http_req_sending"]["p(90)"]
                data_for_csv["http_req_sending_p95"] =  experiment_metrics["http_req_sending"]["p(95)"]

                data_for_csv["http_req_tls_handshaking_avg"] =  experiment_metrics["http_req_tls_handshaking"]["avg"]
                data_for_csv["http_req_tls_handshaking_max"] =  experiment_metrics["http_req_tls_handshaking"]["max"]
                data_for_csv["http_req_tls_handshaking_med"] =  experiment_metrics["http_req_tls_handshaking"]["med"]
                data_for_csv["http_req_tls_handshaking_min"] =  experiment_metrics["http_req_tls_handshaking"]["min"]
                data_for_csv["http_req_tls_handshaking_p90"] =  experiment_metrics["http_req_tls_handshaking"]["p(90)"]
                data_for_csv["http_req_tls_handshaking_p95"] =  experiment_metrics["http_req_tls_handshaking"]["p(95)"]

                data_for_csv["http_req_waiting_avg"] =  experiment_metrics["http_req_waiting"]["avg"]
                data_for_csv["http_req_waiting_max"] =  experiment_metrics["http_req_waiting"]["max"]
                data_for_csv["http_req_waiting_med"] =  experiment_metrics["http_req_waiting"]["med"]
                data_for_csv["http_req_waiting_min"] =  experiment_metrics["http_req_waiting"]["min"]
                data_for_csv["http_req_waiting_p90"] =  experiment_metrics["http_req_waiting"]["p(90)"]
                data_for_csv["http_req_waiting_p95"] =  experiment_metrics["http_req_waiting"]["p(95)"]

                data_for_csv["iteration_duration_avg"] =  experiment_metrics["iteration_duration"]["avg"]
                data_for_csv["iteration_duration_max"] =  experiment_metrics["iteration_duration"]["max"]
                data_for_csv["iteration_duration_med"] =  experiment_metrics["iteration_duration"]["med"]
                data_for_csv["iteration_duration_min"] =  experiment_metrics["iteration_duration"]["min"]
                data_for_csv["iteration_duration_p90"] =  experiment_metrics["iteration_duration"]["p(90)"]
                data_for_csv["iteration_duration_p95"] =  experiment_metrics["iteration_duration"]["p(95)"]

                return data_for_csv
        except Exception as e:
            print(f"Something went wrong. I couldn't process {path} due to {e}")
            pass
            

def main():
    output_file = "json_data_in_csv.csv"
    l = []

    k6runs_dir = "/Users/varadmeru/work/microsoft/azure_functions/AzFunctionsPythonPerformance/k6-configuration/k6runs/"
    prd: ProcessData = ProcessData(k6runs_dir)

    k6runs = filter(lambda x: x.endswith(".json"), os.listdir(k6runs_dir)) # Filtering k6 runs
    for run in k6runs:
        json_to_dict = prd.process_k6_json(run)
        l.append(json_to_dict)

    df = pd.DataFrame(l)
    df.to_csv(output_file)
    df.shape


if __name__ == "__main__":
    main()
