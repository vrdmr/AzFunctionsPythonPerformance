from aiohttp_requests import requests as r

import azure.functions as func
import logging


async def main(req: func.HttpRequest) -> func.HttpResponse:
    response = await r.get("https://raw.githubusercontent.com/vrdmr/AzFunctionsPythonPerformance/master/TestFile")
    return func.HttpResponse(await response.text())
