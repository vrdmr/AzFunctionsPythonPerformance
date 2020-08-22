import logging

import azure.functions as func


async def main(req: func.HttpRequest) -> func.HttpResponse:
    # Pi Calculator
    # By Michael Rouse
    pi = 0
    accuracy = 100000000

    for i in range(0, accuracy):
        
        pi += ((4.0 * (-1)**i) / (2*i + 1))

    return func.HttpResponse(f"{pi}", status_code=200)

