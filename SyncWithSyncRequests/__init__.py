import logging
import requests
import time

import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    r = requests.get("https://raw.githubusercontent.com/anthonychu/python-func-async/master/host.json")
    return func.HttpResponse(f"{r.json()} | ", status_code=200)
