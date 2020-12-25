import logging
import time
import azure.functions as func


async def main(req: func.HttpRequest) -> func.HttpResponse:
    # Pi Calculator
    # By Michael Rouse
    pi = 0
    accuracy = 1000000

    for i in range(0, accuracy):
        pi += ((4.0 * (-1)**i) / (2*i + 1))
    
    time.sleep(1.5)
    for i in range(0, accuracy):
        pi += ((4.0 * (-1)**i) / (2*i + 1))

    return func.HttpResponse(f"{pi}", status_code=200)
