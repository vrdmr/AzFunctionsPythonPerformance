import logging
import os
import sys

import azure.functions as func

# create 300MB random object
big_object = os.urandom(300*1024)


def main(req: func.HttpRequest) -> func.HttpResponse:
    return func.HttpResponse(f"{sys.getsizeof(big_object)}", status_code=200)
