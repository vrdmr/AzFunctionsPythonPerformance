import logging

import azure.functions as func


async def main(req: func.HttpRequest) -> func.HttpResponse:
    return func.HttpResponse("NoOp", status_code=200)
