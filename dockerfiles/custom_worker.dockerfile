
ARG HOST_VERSION=3.0.15584
ARG PYTHON_VERSION=3.8


FROM mcr.microsoft.com/azure-functions/python:$HOST_VERSION-python$PYTHON_VERSION

# Mounting local machines azure-functions-python-worker and azure-functions-python-library onto it
RUN rm -rf /azure-functions-host/workers/python/${PYTHON_VERSION}/LINUX/X64/azure_functions_worker

# Use the following command to run the docker image with customizible worker and library
VOLUME ["/azure-functions-host/workers/python/${PYTHON_VERSION}/LINUX/X64/azure_functions_worker"]

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
    FUNCTIONS_WORKER_PROCESS_COUNT=1 \
    AZURE_FUNCTIONS_ENVIRONMENT=Development

RUN apt-get --quiet update && \
    apt-get install --quiet -y git && \
    cd /home && \
    git clone https://github.com/vrdmr/AzFunctionsPythonPerformance.git && \
    mkdir -p /home/site/wwwroot/ && \
    cp -r AzFunctionsPythonPerformance/* /home/site/wwwroot/ && \
    pip install -q -r /home/site/wwwroot/requirements.txt

CMD [ "/azure-functions-host/Microsoft.Azure.WebJobs.Script.WebHost" ]
