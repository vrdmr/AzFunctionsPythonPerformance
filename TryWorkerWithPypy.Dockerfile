# To enable ssh & remote debugging on app service change the base image to the one below
FROM pypy:3-7
# FROM onlyloggingremoved:1.0.0

RUN apt update && apt -y upgrade && apt update && \
    apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates vim && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - 

RUN apt -y install nodejs && apt -y  install gcc g++ make && \
    npm i -g azure-functions-core-tools@3 --unsafe-perm true

RUN mkdir -p /home/site/wwwroot/ && cd /home/site/wwwroot/
# func init --worker-runtime python --language python
# func new -n HttpTrigger --template HTTPTrigger --language python

RUN cd /usr/lib/node_modules/azure-functions-core-tools/bin/workers/python && \
    sed -i 's/"defaultExecutablePath"\:"python"/"defaultExecutablePath":"pypy3"/g' worker.config.json

COPY requirements.txt /
RUN pypy3 -m pip install --upgrade pip
RUN pypy3 -m pip install -r /requirements.txt

COPY . /home/site/wwwroot

WORKDIR /home/site/wwwroot

CMD [ "func host start --port 8080 --verbose" ]
