# To enable ssh & remote debugging on app service change the base image to the one below
FROM mcr.microsoft.com/azure-functions/python:3.0.14785-python3.7
# FROM onlyloggingremoved:1.0.0
# FROM pyworker39:v2

# RUN cd /azure-functions-host/workers/python/3.6 && \
#     sed -i 's/max_workers=1/max_workers=1/g' OSX/X64/azure_functions_worker/dispatcher.py && \
#     sed -i 's/max_workers=1/max_workers=1/g' LINUX/X64/azure_functions_worker/dispatcher.py

# RUN cd /azure-functions-host/workers/python/3.7 && \
#     sed -i 's/max_workers=1/max_workers=1/g' OSX/X64/azure_functions_worker/dispatcher.py && \
#     sed -i 's/max_workers=1/max_workers=1/g' LINUX/X64/azure_functions_worker/dispatcher.py

# RUN cd /azure-functions-host/workers/python/3.8 && \
#     sed -i 's/max_workers=1/max_workers=1/g' OSX/X64/azure_functions_worker/dispatcher.py && \
#     sed -i 's/max_workers=1/max_workers=1/g' LINUX/X64/azure_functions_worker/dispatcher.py

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
    FUNCTIONS_WORKER_PROCESS_COUNT=1 \
    AZURE_FUNCTIONS_ENVIRONMENT=Development
    # PYTHON_THREADPOOL_THREAD_COUNT=5

COPY requirements.txt /
RUN pip install --upgrade pip
RUN pip install -r /requirements.txt

COPY . /home/site/wwwroot

CMD [ "/azure-functions-host/Microsoft.Azure.WebJobs.Script.WebHost" ]
