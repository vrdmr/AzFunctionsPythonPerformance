$RUN_OUTPUT_FOLDER="k6runs"
$PLAN="consumption"
$CPU="1.0"
$MEMORY="1.5g"
$PORT="8060"
$TEST_LIST = @(
    "async-cpuintensive-sleep.js",
    "async-cpuintensive.js",
    "async-helloworld.js",
    "async-sendingasyncrequests.js",
    "async-sendingsyncrequests.js",
    "sync-cpuintensive-sleep.js",
    "sync-cpuintensive.js",
    "sync-helloworld.js",
    "sync-htmlparsing.js",
    "sync-mixworkloads.js",
    "sync-sendingsyncrequests.js"
)
$WORKER_COUNT_OPTIONS = @("1", "4")
$THREAD_COUNT_OPTIONS = @("1", "5", "10")
$IMAGES = @{
    "wk1-th1" = "rogerxman/python:worker-1-threadpool-1";
    "wk1-th5" = "rogerxman/python:worker-1-threadpool-5";
    "wk1-th10" = "rogerxman/python:worker-1-threadpool-10";
    "wk4-th1" = "rogerxman/python:worker-4-threadpool-1";
    "wk4-th5" = "rogerxman/python:worker-4-threadpool-5";
    "wk4-th10" = "rogerxman/python:worker-4-threadpool-10";
}

$WORKER_MOUNT = "C:\Users\hazeng\Projects\Github\azure-functions-python-worker\azure_functions_worker"
$LIBRARY_MOUNT = "C:\Users\hazeng\Projects\Github\azure-functions-python-library\azure\functions"

docker rm -f (docker ps -aq)

foreach($test_js in $TEST_LIST) {
    foreach($worker_count in $WORKER_COUNT_OPTIONS) {
        foreach($thread_count in $THREAD_COUNT_OPTIONS) {
            $test_name = $test_js.Replace('.js', '')
            $image_name = $IMAGES["wk$worker_count-th$thread_count"]
            $container_name = "$test_name-$PLAN-$CPU-$MEMORY-wk$worker_count-th$thread_count"
            $export_path = "$RUN_OUTPUT_FOLDER/$test_name-$PLAN-$CPU-$MEMORY-wk$worker_count-th$thread_count.json"

            docker run -d --cpus=`"$CPU`" --memory=`"$MEMORY`" -p `"$PORT`:80`" --name `"$container_name`" `
                -v `"$WORKER_MOUNT`:/azure-functions-host/workers/python/3.6/LINUX/X64/azure_functions_worker`" `
                -v `"$LIBRARY_MOUNT`:/azure-functions-host/workers/python/3.6/LINUX/X64/azure/functions`" `
                `"$image_name`"

            Start-Sleep 10

            k6 run --env PORT=$PORT --env PROTOCOL=http --summary-export="$export_path" ".\$test_js"

            docker rm -f $container_name
        }
    }
}




###
### Before Changing 11 and 41
###
docker rm -f (docker ps -aq)

docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8062:80 --name dev-con-new-as11 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_1_POOL_1"; sleep 10; k6 run --env PORT=8062 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-as11.json .\async-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8063:80 --name dev-con-new-aa11 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_1_POOL_1"; sleep 10; k6 run --env PORT=8063 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-aa11.json .\async-sendingasyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8064:80 --name dev-con-new-ss41 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_4_POOL_1"; sleep 10; k6 run --env PORT=8064 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-ss41.json .\sync-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8065:80 --name dev-con-new-as41 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_4_POOL_1"; sleep 10; k6 run --env PORT=8065 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-as41.json .\async-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8066:80 --name dev-con-new-aa41 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_4_POOL_1"; sleep 10; k6 run --env PORT=8066 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-aa41.json .\async-sendingasyncrequests.js

###
### Before Changing 15 and 45
###
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8080:80 --name dev-con-new-ss15 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_1_POOL_5"; sleep 10; k6 run --env PORT=8080 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-ss15.json .\sync-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8086:80 --name dev-con-new-as15 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_1_POOL_5"; sleep 10; k6 run --env PORT=8086 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-as15.json .\async-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8082:80 --name dev-con-new-aa15 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_1_POOL_5"; sleep 10; k6 run --env PORT=8082 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-aa15.json .\async-sendingasyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8083:80 --name dev-con-new-ss45 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_4_POOL_5"; sleep 10; k6 run --env PORT=8083 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-ss45.json .\sync-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8084:80 --name dev-con-new-as45 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_4_POOL_5"; sleep 10; k6 run --env PORT=8084 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-as45.json .\async-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8085:80 --name dev-con-new-aa45 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_4_POOL_5"; sleep 10; k6 run --env PORT=8085 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-aa45.json .\async-sendingasyncrequests.js

###
### Before Changing 110 and 410
###
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8180:80 --name dev-con-new-ss110 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_1_POOL_10"; sleep 10; k6 run --env PORT=8180 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-ss110.json .\sync-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8186:80 --name dev-con-new-as110 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_1_POOL_10"; sleep 10; k6 run --env PORT=8186 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-as110.json .\async-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8182:80 --name dev-con-new-aa110 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_1_POOL_10"; sleep 10; k6 run --env PORT=8182 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-aa110.json .\async-sendingasyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8183:80 --name dev-con-new-ss410 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_4_POOL_10"; sleep 10; k6 run --env PORT=8183 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-ss410.json .\sync-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8184:80 --name dev-con-new-as410 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_4_POOL_10"; sleep 10; k6 run --env PORT=8184 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-as410.json .\async-sendingsyncrequests.js
docker rm -f (docker ps -aq)
docker run -d --cpus="$CPU_COUNT" --memory="$MEMORY_LIMIT" -p 8185:80 --name dev-con-new-aa410 -v "$WORKER_MOUNT" -v "$LIBRARY_MOUNT" "$IMAGE_WORKER_4_POOL_10"; sleep 10; k6 run --env PORT=8185 --env PROTOCOL=http --summary-export=k6runs/dev-con-new-aa410.json .\async-sendingasyncrequests.js