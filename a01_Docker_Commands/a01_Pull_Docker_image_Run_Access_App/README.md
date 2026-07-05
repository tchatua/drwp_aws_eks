# How to Pull and Run Docker Images from Docker Hub and Run


## Pull Docker Image from Docker Hub

```sh
docker images
IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA

# --------------------------------------------------------------------------
docker pull stacksimplify/retail-store-sample-ui:2.0.0
2.0.0: Pulling from stacksimplify/retail-store-sample-ui
250ebb153c96: Pull complete
b6baa302384d: Pull complete
60e102fc2fd5: Pull complete
c687d69d9ded: Pull complete
b74c7ba53c5d: Pull complete
4f4fb700ef54: Pull complete
ab1d182704cb: Pull complete
Digest: sha256:dfdf6c35d13fea69fb5f3ffbe3772f1f47462ebcab26df761c288ee7c2d9682c
Status: Downloaded newer image for stacksimplify/retail-store-sample-ui:2.0.0
docker.io/stacksimplify/retail-store-sample-ui:2.0.0

# --------------------------------------------------------------------------
docker images
IMAGE                                        ID             DISK USAGE   CONTENT SIZE   EXTRA
stacksimplify/retail-store-sample-ui:2.0.0   dfdf6c35d13f        990MB          339MB


```

## Run the Downloaded Docker Image

```sh
# Run Docker Container
docker run --name <CONTAINER-NAME> -p <HOST_PORT>:<CONTAINER_PORT> -d <IMAGE_NAME>:<TAG>
```

```sh
docker run --name myapp1 -p 8888:8080 -d stacksimplify/retail-store-sample-ui:1.0.0

```

```sh
docker run --name myapp1 -p 8888:8080 -d stacksimplify/retail-store-sample-ui:1.0.0
Unable to find image 'stacksimplify/retail-store-sample-ui:1.0.0' locally
1.0.0: Pulling from stacksimplify/retail-store-sample-ui
487a9f124fe2: Pull complete
0b097f308b6a: Pull complete
b5242071ef18: Pull complete
c052007c4d1b: Pull complete
6a1c06ab03e5: Pull complete
4f4fb700ef54: Pull complete
ff2471aaac6d: Pull complete
Digest: sha256:c34bc9af30ecb6ef3af7a641ad0ebe4e94fa482899fe14d840e071a2928e82c7
Status: Downloaded newer image for stacksimplify/retail-store-sample-ui:1.0.0
12242f35226b52f8039a14b39e319b6f0995e9fcf5c093999ab52c4af7803132
# --------------------------------------------------------------------------
docker ps
CONTAINER ID   IMAGE                                        COMMAND                  CREATED         STATUS         PORTS                                         NAMES
12242f35226b   stacksimplify/retail-store-sample-ui:1.0.0   "sh -c 'java $JAVA_O…"   2 minutes ago   Up 2 minutes   0.0.0.0:8888->8080/tcp, [::]:8888->8080/tcp   myapp1
# --------------------------------------------------------------------------
docker ps -a
CONTAINER ID   IMAGE                                        COMMAND                  CREATED          STATUS          PORTS                                         NAMES
12242f35226b   stacksimplify/retail-store-sample-ui:1.0.0   "sh -c 'java $JAVA_O…"   33 minutes ago   Up 33 minutes   0.0.0.0:8888->8080/tcp, [::]:8888->8080/tcp   myapp1
# --------------------------------------------------------------------------
docker exec -it myapp1 /bin/bash

[appuser@12242f35226b ~]$ uname -a
Linux 12242f35226b 5.14.0-611.55.1.el9_7.x86_64 #1 SMP PREEMPT_DYNAMIC Sat May 9 13:31:46 EDT 2026 x86_64 x86_64 x86_64 GNU/Linux

[appuser@12242f35226b ~]$ cat /etc/os-release
NAME="Amazon Linux"
VERSION="2023"
ID="amzn"
ID_LIKE="fedora"
VERSION_ID="2023"
PLATFORM_ID="platform:al2023"
PRETTY_NAME="Amazon Linux 2023.6.20250218"
ANSI_COLOR="0;33"
CPE_NAME="cpe:2.3:o:amazon:amazon_linux:2023"
HOME_URL="https://aws.amazon.com/linux/amazon-linux-2023/"
DOCUMENTATION_URL="https://docs.aws.amazon.com/linux/"
SUPPORT_URL="https://aws.amazon.com/premiumsupport/"
BUG_REPORT_URL="https://github.com/amazonlinux/amazon-linux-2023"
VENDOR_NAME="AWS"
VENDOR_URL="https://aws.amazon.com/"
SUPPORT_END="2029-06-30"

[appuser@12242f35226b ~]$ whoami
appuser

java -version
Picked up JAVA_TOOL_OPTIONS:
openjdk version "21.0.6" 2025-01-21 LTS
OpenJDK Runtime Environment Corretto-21.0.6.7.1 (build 21.0.6+7-LTS)
OpenJDK 64-Bit Server VM Corretto-21.0.6.7.1 (build 21.0.6+7-LTS, mixed mode, sharing)

[appuser@12242f35226b ~]$ curl http://localhost:8080
<!doctype html>
# --------------------------------------------------------------------------
docker exec -it myapp1 ls
LICENSES.md  app.jar
# --------------------------------------------------------------------------
docker exec -it myapp1 env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=12242f35226b
TERM=xterm
APPUSER=appuser
APPUID=1000
APPGID=1000
JAVA_TOOL_OPTIONS=
SPRING_PROFILES_ACTIVE=prod
HOME=/app
# --------------------------------------------------------------------------
docker exec -it myapp1 curl http://localhost:8080
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
```