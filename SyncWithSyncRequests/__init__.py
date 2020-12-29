import logging
import requests
import time

import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    r = requests.get("https://raw.githubusercontent.com/vrdmr/AzFunctionsPythonPerformance/master/TestFile")
    return func.HttpResponse(f"{r.text} | ", status_code=200)
