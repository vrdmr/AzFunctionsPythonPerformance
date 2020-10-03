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