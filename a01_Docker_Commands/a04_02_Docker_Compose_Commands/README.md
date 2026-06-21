# Docker Compose commands

> List Running Services

```sh
# List Services 
docker compose ps
# Also verify Docker images it downloaed
docker images
```

```sh
docker compose ps
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
NAME                             IMAGE                                                              COMMAND                  SERVICE          CREATED          STATUS                            PORTS
retail-sample-cart-1             public.ecr.aws/aws-containers/retail-store-sample-cart:1.3.0       "sh -c 'java $JAVA_O…"   cart             54 minutes ago   Up 5 minutes (healthy)            8080/tcp
retail-sample-carts-db-1         amazon/dynamodb-local:1.20.0                                       "java -jar DynamoDBL…"   carts-db         54 minutes ago   Up 5 minutes (healthy)            8000/tcp
retail-sample-catalog-1          public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0    "/app/main"              catalog          2 minutes ago    Restarting (2) 42 seconds ago
retail-sample-catalog-db-1       mariadb:10.9                                                       "docker-entrypoint.s…"   catalog-db       2 minutes ago    Up 2 minutes (healthy)            3306/tcp
retail-sample-checkout-1         public.ecr.aws/aws-containers/retail-store-sample-checkout:1.3.0   "node dist/main.js"      checkout         54 minutes ago   Up 5 minutes (healthy)
retail-sample-checkout-redis-1   redis:6.0-alpine                                                   "docker-entrypoint.s…"   checkout-redis   54 minutes ago   Up 5 minutes (healthy)            6379/tcp
retail-sample-orders-1           public.ecr.aws/aws-containers/retail-store-sample-orders:1.3.0     "sh -c 'java $JAVA_O…"   orders           2 minutes ago    Up 6 seconds (health: starting)   8080/tcp
retail-sample-orders-db-1        postgres:16.1                                                      "docker-entrypoint.s…"   orders-db        2 minutes ago    Up 2 minutes (healthy)            5432/tcp
retail-sample-rabbitmq-1         rabbitmq:3-management                                              "docker-entrypoint.s…"   rabbitmq         2 minutes ago    Up 2 minutes                      4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 15691-15692/tcp, 25672/tcp

# ---------------------------------------------------------------------------------------------------------------------------------------

docker images
IMAGE                                                          ID             DISK USAGE   CONTENT SIZE   EXTRA
amazon/dynamodb-local:1.20.0                                   1ed00881c937        747MB          211MB    U
mariadb:10.9                                                   56710811b0b9        507MB          119MB    U
postgres:16.1                                                  09f23e02d766        604MB          158MB    U
public.ecr.aws/aws-containers/retail-store-sample-cart:1.3.0   5d767569c976        776MB          247MB    U
public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0 b654b266fa32        285MB         75.5MB    U
public.ecr.aws/aws-containers/retail-store-sample-checkout:1.3.0 687aa68dd490        969MB          162MB    U
public.ecr.aws/aws-containers/retail-store-sample-orders:1.3.0 e85f034bcf48        992MB          340MB    U
public.ecr.aws/aws-containers/retail-store-sample-ui:1.3.0     ce3f2e935eb3        983MB          335MB    U
rabbitmq:3-management                                          e582c0bc7766        387MB          118MB    U
redis:6.0-alpine                                               2b35fc7d2908       44.7MB         12.8MB    U

```
> Stop / Start a Single Service

```sh
# Stop a Service
docker compose stop orders
# Verify if service is stopped
docker compose ps
docker compose ps -a
# Start a Service
docker compose start orders
```

```sh
# ---------------------------------------------------------------------------------------------------------------------------------------
docker compose stop orders
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
WARN[0000] The "DB_PASSWORD" variable is not set. Defaulting to a blank string.
[+] stop 1/1
 ✔ Container retail-sample-orders-1 Stopped         
```

## Run Commands Inside a Container

```sh
# Connect to a Container
docker compose exec ui sh

# Commands to run in container
ls
id
uname -m
uname -n
env
cat /etc/hostname
cat /etc/os-release 
cat /etc/os-release | sed -n '1,6p' 
curl http://localhost:8080
curl http://localhost:8080/topology
curl http://localhost:8080/actuator/health
exit
```

## Restart a Service

```sh
# Restart a Service
docker compose restart cart

# Verify if service restarted
docker compose ps
```

## View Logs

```sh
# Logs for all services
docker compose logs
# Logs for a specific service
docker compose logs checkout
# Follow logs
docker compose logs -f checkout
```

##  Docker Compose Stats

- Display a live stream of container(s) resource usage statistics

```sh
# Stats 
docker compose stats
# Specific Containers
docker compose stats ui
```

## Display the running process in a container

```sh
# Display the running process of all service containers
docker compose top

# Specific containers
docker compose top ui
docker compose top checkout
```

## Make changes to Docker Compose and Deploy
## Force recreate UI Container

```sh
# Stop All Services
docker compose up -d --force-recreate ui

[or]

# Stop All Services
docker compose down 

# Start All Services
docker compose up -d
```

## Clean Up Docker Resources (Optional)

```sh
# Stop and remove containers, networks
docker compose down

# List Docker Containers
docker ps
docker ps -a

# List Docker Images
docker images

# Prune all unused Docker objects (careful!)
docker system prune -a --volumes -f

# List Docker Images
docker images
```

## 

```sh

```

## 

```sh

```

## 

```sh

```

## 

```sh

```

## 

```sh

```


