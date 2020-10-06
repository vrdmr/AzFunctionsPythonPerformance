# Usage
# python show_rate.py --path k6runs

import argparse
import json
import os
import math
from typing import Any, Dict, Iterable
from collections import namedtuple

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
ResultEntry = namedtuple(
    'ResultEntry',
    ['case', 'cpu', 'memory', 'worker', 'thread', 'rate', 'success', 'failure']
)


def parser() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument('--path', required=True, help='Path to jsons folder')
    return parser.parse_args()


def parse_test_result(filename: str, filecontent: Dict[str, Any]) -> ResultEntry:
    pure_filename = filename.replace('.json', '', 1)
    part_filename: Iterable[str] = pure_filename.split('-')
    return ResultEntry(
        case = '-'.join(part_filename[0:-5]),
        cpu = part_filename[-4],
        memory = part_filename[-3],
        worker = part_filename[-2].replace('wk', '', 1),
        thread = part_filename[-1].replace('th', '', 1),
        rate = float(filecontent['metrics']['http_reqs']['rate']),
        success = int(filecontent['metrics']['checks']['passes']),
        failure = int(filecontent['metrics']['checks']['fails'])
    )

def main():
    args = parser()
    json_path = f'{SCRIPT_DIR}{os.path.sep}{args.path}'
    results = []

    for filename in os.listdir(json_path):
        full_filename = f'{json_path}{os.path.sep}{filename}'
        with open(full_filename, 'r') as f:
            file_content = json.load(f)
            results.append(parse_test_result(filename, file_content))

    longest_case = max(results, default='case', key=lambda x: len(x.case))
    longest_name = len(longest_case.case)

    for r in results:
        print(f'{r.case.ljust(longest_name)} cpu={r.cpu.ljust(8)} mem={r.memory.ljust(8)} wk={r.worker.ljust(8)} th={r.thread.ljust(8)} rate={format(r.rate, ".2f").ljust(8)} ( {r.success} | {r.failure} )')

if __name__ == '__main__':
    main()