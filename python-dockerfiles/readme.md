### Create a docker image with customizible worker and library

The python-custom-image.dockerfile allow you to create a image which can mount python worker and python library from your local machine.
`docker build -t <base_image_tag> -f ./python-custom-image.dockerfile .`

### Build a Azure Functions custom container with customizible worker and library image

Use the built image from python-custom-image.dockerfile and use it as the base image in ../Dockerfile.
Built the docker file with benchmarking functions in it by `docker build -t <custom_container_image_tag> -f ../Dockerfile ..`

### Run the image with custom Python worker and library

After building the custom container image, you can run with the following command to mount the Python worker from you local machine to the image.

```bash
docker run --name <container_name> -p <exposed_port>:80 \
    -v <python_worker_path_on_your_machine>/azure_functions_worker:/azure-functions-host/workers/python/3.6/LINUX/X64/azure_functions_worker \
    -v <python_library_path_on_your_machine>/azure/functions:/azure-functions-host/workers/python/3.6/LINUX/X64/azure/functions \
    <image_built_by_project_root_dockerfile>
```
