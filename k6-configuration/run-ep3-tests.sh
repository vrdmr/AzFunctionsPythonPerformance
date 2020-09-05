#!/bin/bash

export RunOutputFolder=k6runs
export PLAN=ep3
export CPU=4
export MEMORY=14g

runk6tests () {
PORT=$1 k6 run --summary-export=asynccpuintensivesleep-$PLAN-$2-summaryexport.json     async-cpuintensive-sleep.js
PORT=$1 k6 run --summary-export=asynccpuintensive-$PLAN-$2-summaryexport.json          async-cpuintensive.js
PORT=$1 k6 run --summary-export=asynchelloworld-$PLAN-$2-summaryexport.json            async-helloworld.js
PORT=$1 k6 run --summary-export=asyncsendingasyncrequests-$PLAN-$2-summaryexport.json  async-sendingasyncrequests.js
PORT=$1 k6 run --summary-export=asyncsendingsyncrequests-$PLAN-$2-summaryexport.json   async-sendingsyncrequests.js
PORT=$1 k6 run --summary-export=synccpuintensivesleep-$PLAN-$2-summaryexport.json      sync-cpuintensive-sleep.js
PORT=$1 k6 run --summary-export=synccpuintensive-$PLAN-$2-summaryexport.json           sync-cpuintensive.js
PORT=$1 k6 run --summary-export=synchelloworld-$PLAN-$2-summaryexport.json             sync-helloworld.js
PORT=$1 k6 run --summary-export=syncmixworkloads-$PLAN-$2-summaryexport.json           sync-mixworkloads.js
PORT=$1 k6 run --summary-export=syncsendingsyncrequests-$PLAN-$2-summaryexport.json    sync-sendingsyncrequests.js
PORT=$1 k6 run --summary-export=synchtmlparsing-$PLAN-$2-summaryexport.json            sync-htmlparsing.js
}

cleanup_docker_container() {
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker system prune --force
}

start_docker() {
    docker run -p $1:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d $2
    sleep 50 # To allow the max case - where all the workers have started
}

for i in 8000,vrdmr/pywinder-wrk1-stp-1:1.0.0 8001,vrdmr/pywinder-wrk4-stp-1:1.0.0 8002,vrdmr/pywinder-wrk4-stp-none:1.0.0 8003,vrdmr/pywinder-wrk1-stp-none:1.0.0 8004,vrdmr/pywinder-wrk1-stp-10:1.0.0 8005,vrdmr/pywinder-wrk4-stp-10:1.0.0 8006,vrdmr/pywinder-nologging-wrk4-stp-10:1.0.0 8007,vrdmr/pywinder-nologging-wrk1-stp-1:1.0.0 8008,vrdmr/pywinder-nologging-wrk4-stp-1:1.0.0 8009,vrdmr/pywinder-nologging-wrk1-stp-10:1.0.0; do 
    IFS=',' read item1 item2 <<< "${i}"
    echo Running "${item2}" image on "${item1}" port
    IFS='/' read scope fullimagename <<< "${item2}"
    IFS=':' read imagename tag <<< "${fullimagename}"
    start_docker "${item1}" "${item2}"

    echo Starting test suite now. All the best!
    runk6tests "${item1}" "${imagename}"
    cleanup_docker_container
done