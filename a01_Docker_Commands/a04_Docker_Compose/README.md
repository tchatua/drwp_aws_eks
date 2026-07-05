# Docker Compose

```css
Running a complete microservices-based retail application using Docker Compose.
Use docker-compose.yaml to define 10 interdependent services including databases, APIs, messaging, and a UI and manage them all with just a few commands.
```

![alt text](image.png)

## What is Docker Compose?

Docker Compose is a tool for:

- Defining multi-container apps in a single YAML file
- Managing networks, volumes, dependencies
- Running all services with docker compose up
- Testing, tearing down, and rebuilding environments easily

## Install Docker Compose

```sh
docker compose version
Docker Compose version v5.1.4
```

## Retail Store Application - Architecture Overview

![alt text](image-1.png)

## Without Docker Compose

![alt text](image-2.png)

## How Docker Compose Solves It

![alt text](image-3.png)

## Install Docker Compose (if not available)

```sh
# Create the CLI plugin directory
sudo mkdir -p /usr/local/lib/docker/cli-plugins
# Download the latest Docker Compose v2 binary (always pulls the newest release)
wget https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -O docker-compose
# Make it executable
chmod +x docker-compose
# Move it to the CLI plugins directory
sudo mv docker-compose /usr/local/lib/docker/cli-plugins/docker-compose
# Verify install
docker compose version
```

## Services Used in This Project

1. Application: cart
- Image: public.ecr.aws/aws-containers/retail-store-sample-cart:1.3.0

2. Application: carts-db
- Image: amazon/dynamodb-local:1.20.0

3. Application: catalog
- Image: public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0

4. Application: catalog-db
- Image: mariadb:10.9

5. Application: checkout
- Image: public.ecr.aws/aws-containers/retail-store-sample-checkout:1.3.0

6. Application: checkout-redis
- Image: redis:6.0-alpine

7. Application: orders
- Image: public.ecr.aws/aws-containers/retail-store-sample-orders:1.3.0

8. Application: orders-db
- Image: postgres:16.1

9. Application: rabbitmq
- Image: rabbitmq:3-management

10. Application: ui
- Image: public.ecr.aws/aws-containers/retail-store-sample-ui:1.3.0

```sh
# -------------------------------------------------------------------------------------------------------------------------
# Download the Docker Compose file
wget https://github.com/aws-containers/retail-store-sample-app/releases/download/v1.3.0/docker-compose.yaml
--2026-06-02 02:25:33--  https://github.com/aws-containers/retail-store-sample-app/releases/download/v1.3.0/docker-compose.yaml
Resolving github.com (github.com)... 140.82.113.4
Connecting to github.com (github.com)|140.82.113.4|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://release-assets.githubusercontent.com/github-production-release-asset/545589732/47e9a9c1-7ee1-45fa-b901-5be1c4ce08a4?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-06-02T03%3A15%3A05Z&rscd=attachment%3B+filename%3Ddocker-compose.yaml&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-06-02T02%3A14%3A41Z&ske=2026-06-02T03%3A15%3A05Z&sks=b&skv=2018-11-09&sig=lj3B5rynjixugYfuadyin3%2BTKQPVr2FGwl9SJ1gcd3Q%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc4MDM2NzQzNCwibmJmIjoxNzgwMzY3MTM0LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.C0lAoYCcQCGYgDU2Hc5s4iXjbzvvu9FxK4gjSsEJ0po&response-content-disposition=attachment%3B%20filename%3Ddocker-compose.yaml&response-content-type=application%2Foctet-stream [following]
--2026-06-02 02:25:34--  https://release-assets.githubusercontent.com/github-production-release-asset/545589732/47e9a9c1-7ee1-45fa-b901-5be1c4ce08a4?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-06-02T03%3A15%3A05Z&rscd=attachment%3B+filename%3Ddocker-compose.yaml&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-06-02T02%3A14%3A41Z&ske=2026-06-02T03%3A15%3A05Z&sks=b&skv=2018-11-09&sig=lj3B5rynjixugYfuadyin3%2BTKQPVr2FGwl9SJ1gcd3Q%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc4MDM2NzQzNCwibmJmIjoxNzgwMzY3MTM0LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.C0lAoYCcQCGYgDU2Hc5s4iXjbzvvu9FxK4gjSsEJ0po&response-content-disposition=attachment%3B%20filename%3Ddocker-compose.yaml&response-content-type=application%2Foctet-stream
Resolving release-assets.githubusercontent.com (release-assets.githubusercontent.com)... 185.199.109.133, 185.199.110.133, 185.199.111.133, ...
Connecting to release-assets.githubusercontent.com (release-assets.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7212 (7.0K) [application/octet-stream]
Saving to: ‘docker-compose.yaml’

docker-compose.yaml         100%[==========================================>]   7.04K  --.-KB/s    in 0s

2026-06-02 02:25:34 (62.9 MB/s) - ‘docker-compose.yaml’ saved [7212/7212]

# -------------------------------------------------------------------------------------------------------------------------
$>ll
-rw-r--r--. 1 ec2-user ec2-user 7212 Sep 16  2025 docker-compose.yaml

# -------------------------------------------------------------------------------------------------------------------------
# Set environment variable
export DB_PASSWORD='Qwerty2026'

echo $DB_PASSWORD
Qwerty2026

# -------------------------------------------------------------------------------------------------------------------------
# Start all services
## Important Note:  if my file name is docker-compose.yaml dont need to specify -f with file
docker compose -f docker-compose.yaml up
docker compose docker-compose.yaml up
docker compose up 
# -------------------------------------------------------------------------------------------------------------------------
# OR start in detached mode (background)
docker compose -f docker-compose.yaml up -d
docker compose up -d
# -------------------------------------------------------------------------------------------------------------------------
docker compose up -d
[+] up 10/10
 ✔ Container retail-sample-carts-db-1       Healthy                                                        0.6s
 ✔ Container retail-sample-cart-1           Healthy                                                        5.6s
 ✔ Container retail-sample-catalog-db-1     Healthy                                                        0.6s
 ✔ Container retail-sample-catalog-1        Healthy                                                        1.1s
 ✔ Container retail-sample-orders-db-1      Healthy                                                        0.6s
 ✔ Container retail-sample-orders-1         Healthy                                                       11.1s
 ✔ Container retail-sample-checkout-redis-1 Healthy                                                        0.6s
 ✔ Container retail-sample-rabbitmq-1       Running                                                        0.0s
 ✔ Container retail-sample-checkout-1       Healthy                                                        1.1s
 ✔ Container retail-sample-ui-1             Started
```

![alt text](image-4.png)

![alt text](image-5.png)









