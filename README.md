# Spring Boot Microservice Layout

## Tech Stack

This repository provides the basic configuration for a proper microservice using
the folloring tech stack:

- [Java 25 LTS](https://docs.oracle.com/en/java/javase/25/): The latest Java
  Long Term Support version.
- [Spring Boot v4.0.5](https://github.com/spring-projects/spring-boot): Latest
  stable version.
- Docker: For containerization & deployment.
- [MySQL v8.4 LTS](https://hub.docker.com/_/mysql)

## CI

- Formatter:
  [Google Java Formatter](https://github.com/google/google-java-format)
- Migrations: [Flyway](url)
- prettier:

## Design

The application is going to use a Microservice architecture. This are the
current microservices with they descriptions.

```mermaid
graph TD
    Users[Users Service]
    Auth[Authentication Service]
    Sales[Sales Service]
    Invoices[Invoices Service]
```

### Users

Responsibility: Handle all CRUD operations and things like orchestrating the
password recovery.

| id  | rut | dv  | name       | ... | insert_at  | modified_at | deleted_at |
| --- | --- | --- | ---------- | --- | ---------- | ----------- | ---------- |
| 1   | 123 | k   | Alan Brito | ... | 2026-03-01 | 2026-04-12  | 2026-04-17 |
| 2   | 123 | k   | Brito      | ... | 2026-03-01 | 2026-04-12  |            |

### Authentication

Responsibility: Validate users credentials.

### Sales

Responsibility: Orchestrate sales and related operations.

### Invoices

Responsibility: Store and retrieve invoice registers.

### OperationsMonitor

Responsibility:
