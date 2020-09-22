#!/bin/bash

export RunOutputFolder=k6runs
export PLAN=consumption
export CPU=1
export MEMORY=1.5g

runk6tests () {
  #PORT=$1 k6 run --summary-export=$RunOutputFolder/asynccpuintensivesleep-$PLAN-$2-summaryexport.json     async-cpuintensive-sleep.js
  #PORT=$1 k6 run --summary-export=$RunOutputFolder/asynccpuintensive-$PLAN-$2-summaryexport.json          async-cpuintensive.js
  #PORT=$1 k6 run --summary-export=$RunOutputFolder/asynchelloworld-$PLAN-$2-summaryexport.json            async-helloworld.js
  PORT=$1 k6 run --summary-export=$RunOutputFolder/asyncsendingasyncrequests-$PLAN-$2-summaryexport.json  async-sendingasyncrequests.js
  PORT=$1 k6 run --summary-export=$RunOutputFolder/asyncsendingsyncrequests-$PLAN-$2-summaryexport.json   async-sendingsyncrequests.js
  #PORT=$1 k6 run --summary-export=$RunOutputFolder/synccpuintensivesleep-$PLAN-$2-summaryexport.json      sync-cpuintensive-sleep.js
  #PORT=$1 k6 run --summary-export=$RunOutputFolder/synccpuintensive-$PLAN-$2-summaryexport.json           sync-cpuintensive.js
  #PORT=$1 k6 run --summary-export=$RunOutputFolder/synchelloworld-$PLAN-$2-summaryexport.json             sync-helloworld.js
  #PORT=$1 k6 run --summary-export=$RunOutputFolder/syncmixworkloads-$PLAN-$2-summaryexport.json           sync-mixworkloads.js
  PORT=$1 k6 run --summary-export=$RunOutputFolder/syncsendingsyncrequests-$PLAN-$2-summaryexport.json    sync-sendingsyncrequests.js
  #PORT=$1 k6 run --summary-export=$RunOutputFolder/synchtmlparsing-$PLAN-$2-summaryexport.json            sync-htmlparsing.js
}

cleanup_docker_container() {
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker system prune --force
}

start_docker() {
    docker run -p $1:80 \
      --cap-add SYS_PTRACE \
      --cpus=$CPU \
      --memory=$MEMORY \
      -v //c/Users/hazeng/Projects/Github/azure-functions-python-worker/azure_functions_worker:/azure-functions-host/workers/python/3.6/LINUX/X64/azure_functions_worker \
      -v //c/Users/hazeng/Projects/Github/azure-functions-python-library/azure/functions:/azure-functions-host/workers/python/3.6/LINUX/X64/azure/functions \
      -d $2
    sleep 50 # To allow the max case - where all the workers have started
}

for i in 8080,rogerxman/python-wrk1-stp-1:1.0.0 ; do
    IFS=',' read item1 item2 <<< "${i}"
    echo Running "${item2}" image on "${item1}" port
    IFS='/' read scope fullimagename <<< "${item2}"
    IFS=':' read imagename tag <<< "${fullimagename}"
    start_docker "${item1}" "${item2}"

    echo Starting test suite now. All the best!
    runk6tests "${item1}" "${imagename}"
    cleanup_docker_container
done