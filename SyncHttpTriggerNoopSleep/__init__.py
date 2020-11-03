import logging

import azure.functions as func
import time


def main(req: func.HttpRequest) -> func.HttpResponse:
    time.sleep(0.1)
    return func.HttpResponse("NoOp Sleep 0.1 Second", status_code=200)
