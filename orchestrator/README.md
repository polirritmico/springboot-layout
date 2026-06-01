# FullStack Microservices Orchestrator

This repository orchestrates the deployment of multiple Spring Boot
microservices, a MySQL database, and phpMyAdmin using Docker Compose.

## Services and Ports Layout

Here are the current port mappings for the active services:

| Service                    | External Port (Host) | Internal Port (Container) | Description                             |
| :------------------------- | :------------------- | :------------------------ | :-------------------------------------- |
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

## Quick Start

Run the following command to clone all uncommented repositories, generate the
database initialization script, build the images, and start the containers:

```bash
make run
```

### Other Available Commands

- `make setup`: Prepares the workspace (clones repos, removes tests, and builds
  the `init.sql` script into a volume)
- `make build`: Compiles Docker images for all services (runs `setup`
  automatically)
- `make up`: Runs the containers in the foreground
- `make start`: Runs the containers detached in the background
- `make stop`: Stops active containers without wiping data
- `make clean`: Teardown (stops containers, wipes Docker volumes, deletes cloned
  repos, and cleans up scripts)

## Database Architecture

A single MySQL container is spun up for the entire network. To ensure isolation,
the `Makefile` dynamically creates an initialization script based on the active
repositories. This script provisions a separate, dedicated database schema for
each microservice upon startup via a Docker named volume (`mysql_init_volume`).

