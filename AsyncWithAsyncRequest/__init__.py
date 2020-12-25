from aiohttp_requests import requests as r

import azure.functions as func
import logging


async def main(req: func.HttpRequest) -> func.HttpResponse:
    response = await r.get("https://raw.githubusercontent.com/anthonychu/python-func-async/master/host.json")
    return func.HttpResponse(await response.text())
