# FullStack Microservices Orchestrator

<!--toc:start-->

- [FullStack Microservices Orchestrator](#fullstack-microservices-orchestrator)
  - [Quick Start](#quick-start)
  - [Pseudo manual run](#pseudo-manual-run)
  - [Services and Ports Layout](#services-and-ports-layout)
    - [Available Make Commands](#available-make-commands)
  - [Database Architecture](#database-architecture)

<!--toc:end-->

This repository orchestrates the deployment of multiple Spring Boot
microservices, a MySQL database, and phpMyAdmin using Docker Compose.

## Quick Start

Run the following command to clone all uncommented repositories, generate the
database initialization script, build the images, and start the containers:

```bash
make run
```

- **Swagger UI:** All microservices have their API documentation available at
  `/swagger-ui/index.html` on their respective host ports.
- **Database Access:** You can inspect the project databases via phpMyAdmin at
  `http://localhost:8088`. Use the credentials **user** and **password**.

## Services and Ports Layout

Here are the current port mappings for the active services:

| Service                    | External Port (Host) | Internal Port (Container) | Description                             |
| :------------------------- | :------------------- | :------------------------ | :-------------------------------------- |
| **Eureka Service**         | `8123`               | `8123`                    | Eureka                                  |
| **API Gateway**            | `8080`               | `8080`                    | Project API gateway.                    |
| **Auth API**               | `8000`               | `8080`                    | Auth microservice                       |
| **Users API**              | `8001`               | `8080`                    | Users microservice                      |
| **Sales API**              | `8002`               | `8080`                    | Sales microservice                      |
| **Invoice API**            | `8003`               | `8080`                    | Invoice microservice                    |
| **Carts API**              | `8004`               | `8080`                    | Carts microservice                      |
| **Product API**            | `8005`               | `8080`                    | Product microservice                    |
| **Pets API**               | `8006`               | `8080`                    | Pets microservice                       |
| **Appointments API**       | `8007`               | `8080`                    | Appointments microservice               |
| **Vets API**               | `8008`               | `8080`                    | Vets microservice                       |
| **Store Manager API**      | `8009`               | `8080`                    | Store Manager microservice              |
| **Accounting Manager API** | `8010`               | `8080`                    | Accounting Manager microservice         |
| **Vet Manager API**        | `8011`               | `8080`                    | Vet Manager microservice                |
| **MySQL DB**               | `3306`               | `3306`                    | Main MySQL database hosting all schemas |
| **phpMyAdmin**             | `8088`               | `80`                      | Web interface for MySQL database        |

## Deploy

These are the instructions to deploy a demo of the app on AWS EC2.

### 1. Network Setup

1. Create a **Security Group** with the following rules:
   - **Inbound:**
     - Frontend: Custom TCP, port `4173`, source `0.0.0.0/0`
     - Backend: Custom TCP, port `8080`, source `0.0.0.0/0`
     - Database: Custom TCP, port `8088`, source `0.0.0.0/0`
     - Administration: SSH, port `22`, source `0.0.0.0/0`
   - **Outbound:**
     - All traffic, port `All`, destination `0.0.0.0/0`
2. Allocate **2 Elastic IPs** and take note of both addresses (one for the
   backend, one for the frontend).

### 2. Provision Instances

Create a Launch Template (or configure each instance directly) using the specs
below, attach the **Security Group** created in step 1 to both, and assign one
**Elastic IP** to each instance after launch.

#### Backend Instance

- **Instance type:** `t3.large` (8 GB RAM)
- **Storage:** 24 GB
- **OS:** Ubuntu Server
- **User data initialization script:**

  ```bash
  #!/usr/bin/env bash
  set -euo pipefail

  apt-get update -y
  apt-get install -y make git

  curl -fsSL https://get.docker.com | sh
  usermod -aG docker ubuntu

  su - ubuntu -c "git clone -b for-frontend https://github.com/polirritmico/springboot-layout.git /home/ubuntu/springboot-layout"
  ```

#### Frontend Instance

- **Instance type:** `t3.medium` (4 GB RAM)
- **Storage:** 24 GB
- **OS:** Ubuntu Server
- **User data initialization script:**

  ```bash
  #!/usr/bin/env bash
  set -euo pipefail

  export DEBIAN_FRONTEND=noninteractive

  apt-get update -y
  apt-get install -y make git curl ca-certificates

  su - ubuntu -c 'git clone -b dev https://github.com/polirritmico/fullstack-frontend.git /home/ubuntu/fullstack-frontend'

  su - ubuntu -c 'curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.0/install.sh | bash'

  su - ubuntu -c 'export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh" && nvm install 26 && nvm alias default 26'

  su - ubuntu -c 'export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh" && cd /home/ubuntu/fullstack-frontend && npm install'
  ```

### 3. Start Services

1. **Deploy the Backend:** Connect to the backend instance and start the
   services using the **frontend** Elastic IP for CORS:

   ```bash
   ssh ubuntu@<backend-public-ip> -i jkiltro.pem
   cd springboot-layout/orchestrator
   CORS_ALLOWED_ORIGINS="http://<frontend-public-ip>:4173" make deploy
   ```

> [!NOTE]
>
> The backend startup takes around 10-15 minutes (?!) to complete.

2. **Deploy the Frontend:** Connect to the frontend instance, configure the
   **backend** Elastic IP, build, and run the preview server:
   ```bash
   ssh ubuntu@<frontend-public-ip> -i jkiltro.pem
   cd fullstack-frontend && cp .env.development .env
   export VITE_JKILTRO_API="http://<backend-public-ip>:8080" && npm run build
   nohup npm run preview -- --host 0.0.0.0 > frontend.log 2>&1 &
   disown
   ```

Done! Check the site in a browser through `http://<frontend-public-ip>:4173`.
You could check the DB through the exposed **phpMyAdmin** container at
`http://<backend-public-ip>:8088`.

## Available Make Commands

- `make run`: One-shot command to clone, generate scripts, build, and run in
  foreground
- `make detached`: Runs the containers detached in the background
- `make stop`: Stops active containers without wiping data
- `make clean`: Teardown. Stops containers, wipes volumes, and init scripts
- `make clean-full`: Deep teardown. Also wipes cloned repositories
- `make setup`: Prepares the workspace (clones repos and builds init.sql)
- `make build`: Compiles docker images for all services (runs setup
  automatically)
- `make clone`: Clones all required service repositories
- `make db-init`: Generates database initialization script
- `make help`: Show the list of available targets

## Database Architecture

A single MySQL container is spun up for the entire network. To ensure isolation,
the `Makefile` dynamically creates an initialization script based on the active
repositories. This script provisions a separate, dedicated database schema for
each microservice upon startup via a Docker named volume (`mysql_init_volume`).
