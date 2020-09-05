#!/bin/zsh

export PLAN=ep3
export CPUs=4
export MEMORY=14g

runk6tests () {
  PORT=$1 k6 run --out json=./k6runs/asynccpuintensivesleep-$PLAN-$2.json    async-cpuintensive-sleep.js
  PORT=$1 k6 run --out json=./k6runs/asynccpuintensive-$PLAN-$2.json         async-cpuintensive.js
  PORT=$1 k6 run --out json=./k6runs/asynchelloworld-$PLAN-$2.json           async-helloworld.js
  PORT=$1 k6 run --out json=./k6runs/asyncsendingasyncrequests-$PLAN-$2.json async-sendingasyncrequests.js
  PORT=$1 k6 run --out json=./k6runs/asyncsendingsyncrequests-$PLAN-$2.json  async-sendingsyncrequests.js
  PORT=$1 k6 run --out json=./k6runs/synccpuintensivesleep-$PLAN-$2.json     sync-cpuintensive-sleep.js
  PORT=$1 k6 run --out json=./k6runs/synccpuintensive-$PLAN-$2.json          sync-cpuintensive.js
  PORT=$1 k6 run --out json=./k6runs/synchelloworld-$PLAN-$2.json            sync-helloworld.js
  PORT=$1 k6 run --out json=./k6runs/syncmixworkloads-$PLAN-$2.json          sync-mixworkloads.js
  PORT=$1 k6 run --out json=./k6runs/syncsendingsyncrequests-$PLAN-$2.json   sync-sendingsyncrequests.js
  PORT=$1 k6 run --out json=./k6runs/synchtmlparsing-$PLAN-$2.json           sync-htmlparsing.js
}

cleanup_docker_container() {
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker system prune --force
}

docker run -p 8080:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-wrk1-stp-1:1.0.0
runk6tests 8000 pywinder-wrk1-stp-1
cleanup_docker_container

docker run -p 8001:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-wrk4-stp-1:1.0.0
runk6tests 8001 pywinder-wrk4-stp-1
cleanup_docker_container

docker run -p 8002:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-wrk4-stp-none:1.0.0
runk6tests 8002 pywinder-wrk4-stp-none
cleanup_docker_container

docker run -p 8003:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-wrk1-stp-none:1.0.0
runk6tests 8003 pywinder-wrk1-stp-none
cleanup_docker_container

docker run -p 8004:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-wrk1-stp-10:1.0.0
runk6tests 8004 pywinder-wrk1-stp-10
cleanup_docker_container

docker run -p 8005:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-wrk4-stp-10:1.0.0
runk6tests 8005 pywinder-wrk4-stp-10
cleanup_docker_container

docker run -p 8006:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-nologging-wrk4-stp-10:1.0.0
runk6tests 8006 pywinder-nologging-wrk4-stp-10
cleanup_docker_container

docker run -p 8007:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-nologging-wrk1-stp-1:1.0.0
runk6tests 8007 pywinder-nologging-wrk1-stp-1
cleanup_docker_container

docker run -p 8008:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-nologging-wrk4-stp-1:1.0.0
runk6tests 8008 pywinder-nologging-wrk4-stp-1
cleanup_docker_container

docker run -p 8009:80 --cap-add SYS_PTRACE --cpus=$CPU --memory=$MEMORY -d vrdmr/pywinder-nologging-wrk1-stp-10:1.0.0
runk6tests 8009 pywinder-nologging-wrk1-stp-10
cleanup_docker_container

