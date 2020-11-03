# To enable ssh & remote debugging on app service change the base image to the one below
# FROM mcr.microsoft.com/azure-functions/python:3.0.14492-python3.7
FROM mcr.microsoft.com/azure-functions/python:3.0.14916-python3.8

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
    PYTHON_THREADPOOL_THREAD_COUNT=5 \
    AZURE_FUNCTIONS_ENVIRONMENT=Development

# RUN apt update && apt -y upgrade && apt update && apt -y install libgl1-mesa-dev
COPY requirements.txt /
RUN pip install --upgrade pip && pip install -r /requirements.txt && apt-get install -y vim

COPY . /home/site/wwwroot