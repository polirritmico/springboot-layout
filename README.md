# 🚀 Spring Boot Microservice Layout

## Description

This repository provides a configuration layout for each microservice of the
project. The idea is to apply the provided settings and files into all the
microservices to unify workflows between developers.

> [!IMPORTANT]
>
> **Too long; didn't read:**
>
> This is the step-by-step setup:
>
> <details>
> <summary> Click to expand </summary>
>
> 1. Name the repo like this: `foo-api` (prefer plural)
> 2. With the initializr:
>    1. Set the project to:
>       - Maven
>       - Java 25
>       - Spring Boot 4.0.6
>       - Group: `cl.duoc`
>       - Artifact: `microservice-name`
>    2. Add the following dependencies:
>       - Lombok
>       - Validation
>       - Spring Boot DevTools
>       - Spring Web
>       - SpringDoc
>       - Spring Data JPA
>       - Driver Mysql
>       - Flyway Migration
>       - Spring Reactive Web
>       - Spring Security
> 3. Copy the files into the microservice repository:
>    - `.env.example`
>    - `.gitattributes`
>    - `.gitignore`
>    - `Dockerfile`
>    - `compose.yml`
>    - `src/main/resources/application-dev.properties`
>    - `src/main/resources/application-prod.properties`
>    - `src/main/resources/application.properties`
>    - `src/main/resources/logback-spring.xml`
> 4. In the `.env.example`, change:
>    - `SPRING_APP_NAME = FooMicroservice`
>    - `MYSQL_DATABASE = foo`
> 5. Copy the security class files from `security` into the
>    `src/main/java/foo/security` dir:
>    - Correct the package path on both files:
>
>    > ```java
>    > package cl.duoc.foo.security;
>    > ```
>
> 6. Add the dependencies and plugins to the `pom.xml` file:
>
>    > ```xml
>    > <dependency>
>    > 	<groupId>com.auth0</groupId>
>    > 	<artifactId>java-jwt</artifactId>
>    > 	<version>4.5.2</version>
>    > </dependency>
>    >
>    > ```
>    >
>    > ```xml
>    > <dependency>
>    > 	<groupId>net.logstash.logback</groupId>
>    > 	<artifactId>logstash-logback-encoder</artifactId>
>    > 	<version>7.4</version>
>    > </dependency>
>    > ```
>    >
>    > <details>
>    > <summary> Click to expand </summary>
>    >
>    > ```xml
>    > 	<build>
>    > 		<plugins>
>    > 			<plugin>
>    > 				<groupId>com.diffplug.spotless</groupId>
>    > 				<artifactId>spotless-maven-plugin</artifactId>
>    > 				<version>2.43.0</version>
>    > 				<configuration>
>    > 					<java>
>    > 						<licenseHeader>
>    > 							<content><![CDATA[/*
>    > 								* Copyright © $YEAR DuocUC FullStack 1
>    > 								* Eduardo Bray
>    > 								* Rodrigo Callealta
>    > 								* Fernando Villalobos
>    > 								*/
>    > 								]]></content>
>    > 						</licenseHeader>
>    > 						<palantirJavaFormat>
>    > 							<version>2.90.0</version>
>    > 							<style>PALANTIR</style>
>    > 							<formatJavadoc>true</formatJavadoc>
>    > 						</palantirJavaFormat>
>    > 					</java>
>    > 					<formats>
>    > 						<format>
>    > 							<includes>
>    > 								<include>**/*.properties</include>
>    > 							</includes>
>    > 							<trimTrailingWhitespace />
>    > 							<endWithNewline />
>    > 						</format>
>    > 						<format>
>    > 							<includes>
>    > 								<include>**/*.md</include>
>    > 							</includes>
>    > 							<trimTrailingWhitespace />
>    > 							<endWithNewline />
>    > 						</format>
>    > 						<format>
>    > 							<includes>
>    > 								<include>compose.yml</include>
>    > 							</includes>
>    > 							<indent>
>    > 								<spaces>true</spaces>
>    > 								<spacesPerTab>2</spacesPerTab>
>    > 							</indent>
>    > 							<trimTrailingWhitespace />
>    > 							<endWithNewline />
>    > 						</format>
>    > 						<format>
>    > 							<includes>
>    > 								<include>pom.xml</include>
>    > 								<include>**/*.xml</include>
>    > 							</includes>
>    > 							<excludes>
>    > 								<exclude>**/logback-spring.xml</exclude>
>    > 							</excludes>
>    > 							<eclipseWtp>
>    > 								<type>XML</type>
>    > 							</eclipseWtp>
>    > 							<indent>
>    > 								<tabs>true</tabs>
>    > 								<spacesPerTab>4</spacesPerTab>
>    > 							</indent>
>    > 						</format>
>    > 					</formats>
>    > 				</configuration>
>    > 				<executions>
>    > 					<execution>
>    > 						<goals>
>    > 							<goal>apply</goal>
>    > 						</goals>
>    > 						<phase>validate</phase>
>    > 					</execution>
>    > 				</executions>
>    > 			</plugin>
>    > 		</plugins>
>    > 	</build>
>    > ```
>    >
>    > </details>
>
> 7. Add this artifact name in the `pom.xml` (do not change the value):
>
>    ```xml
>    <build>
>    	<finalName>app-microservice</finalName>
>    		etc ...
>    ```
>
> 8. Add the `exclude` to the application class in
>    (`src/main/java/cl/duoc/foo/`):
>
>    ```java
>    @SpringBootApplication(exclude = {UserDetailsServiceAutoConfiguration.class})
>    public class FooApplication {
>       // etc...
>    ```
>
> </details>

## Design

<img width="1994" height="1600" alt="architecture_v1" src="https://github.com/user-attachments/assets/e6ad8770-021e-465f-bfa1-4fae5c6693e4" />

## Microservices

The application uses a Microservice architecture. This are the current
microservices with they descriptions.

| Name              | Repository                                                                                          | Domain         | Description                                                          |
| ----------------- | --------------------------------------------------------------------------------------------------- | -------------- | -------------------------------------------------------------------- |
| Auth              | [polirritmico/auth-api](https://github.com/polirritmico/auth-api)                                   | System         | Handle user authentication & provides the JWT                        |
| Users             | [lironscallealta/users-api](https://github.com/lironscallealta/users-api)                           | System         | Manages user CRUD, roles, and contact data                           |
| Sales             | [polirritmico/sales-api](https://github.com/polirritmico/sales-api)                                 | Accounting     | Handle sales data                                                    |
| Invoice           | [Fervivi/invoice-api](https://github.com/Fervivi/invoice-api)                                       | Accounting     | Generates billing docs                                               |
| AccountingManager | [lironscallealta/accounting-manager-api](https://github.com/lironscallealta/accounting-manager-api) | Accounting     | Orchestrates purchases, billing views, and void operations           |
| Carts             | [polirritmico/carts-api](https://github.com/polirritmico/carts-api)                                 | Store          | Handle store carts operations and data                               |
| Products          | [Fervivi/product-api](https://github.com/Fervivi/product-api)                                       | Store          | Manage product catalog                                               |
| StoreManager      | [Fervivi/store-manager-api](https://github.com/Fervivi/store-manager-api)                           | Store          | Coordinates store oper. between microservices                        |
| Pets              | [lironscallealta/pets-api](https://github.com/lironscallealta/pets-api)                             | Clinic         | Manages pets data                                                    |
| Appoinments       | [polirritmico/appointments-api](https://github.com/polirritmico/appointments-api)                   | Clinic         | Handle appointments scheduling & clinical registers                  |
| Veterinarian      | [lironscallealta/vets-api](https://github.com/lironscallealta/vets-api)                             | Clinic         | Manages veterinarian CRUD, professional registry, and work schedules |
| VetManager        | [polirritmico/vet-manager-api](https://github.com/polirritmico/vet-manager-api)                     | Clinic         | Transform domain usecases into microservices calls                   |
| Eureka Server     | [polirritmico/eureka-server](https://github.com/polirritmico/eureka-server)                         | Infrastructure | Discovers and register microservice instances                        |
| API Gateway       | [polirritmico/api-gateway](https://github.com/polirritmico/api-gateway)                             | Infrastructure | Redirect requests to the proper microservice                         |

---

## Tech Stack

### Infrastructure:

- [Java 25 LTS](https://docs.oracle.com/en/java/javase/25/): The latest Java
  Long Term Support version.
- [Spring Boot v4.0.6](https://github.com/spring-projects/spring-boot): Latest
  stable version.
- [Docker](https://docs.docker.com/) &
  [Docker Compose](https://docs.docker.com/compose/): For containerization,
  develop environment & deployment.
- [MySQL v8.4 LTS](https://hub.docker.com/_/mysql): Database

### Dependencies:

1. **Lombok:** Reduce boilerplate
2. **Validation:** Jakarta bean validation
3. **Spring Boot DevTools:** Autoreload & quality of life enhancements
4. **Spring Web:** Provides REST capabilities for MVC
5. **SpringDoc:** Provides autogenerated OpenAPI documentation (AKA Swagger)
6. **Spring Data JPA:** ORM
7. **Driver Mysql:** Handles the DB connection
8. **Flyway Migration:** DB migrations
9. **Spring Reactive Web:** Provides HTTP requests capabilities
10. **Spring Security:** Provides authentication and access-control capabilities
11. [Spotless Maven](https://github.com/diffplug/spotless/blob/main/plugin-maven/README.md#java)
    and
    [Palantir java format](https://marketplace.visualstudio.com/items?itemName=szykk1993.palantir-java-format):
    Code autoformatter for consistent code style.

## Standarization

### General

- Project code should be written in English. Temporary comments or notes may be
  written in Spanish.

> [!NOTE]
>
> The only exception to this rule applies to domain-specific terms that must
> match external systems, such as legal or tax-related fields.

### Project Metadata

- The microservice app name should end with `Microservice`. For example:
  `FooMicroservice`.
- Maven metadata:
  - The **group** should begin with `cl.duoc`.
  - The **artifact** should use lowercase letters only, avoid spaces and use `-`
    instead.

### Naming conventions

#### Tables

- Table names & columns should be in `snake_case`.
- Table names should be in plural

#### Classes/Entities

There's no enforcement on the microservice code names or approaches. Just the
following suggestions:

| Type                   | Recommendation                                                    | Examples                                                            |
| ---------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------- |
| Entities               | Singular                                                          | User, Payment                                                       |
| Services               | Singular                                                          | UserService, PaymentService                                         |
| Repositories           | Singular                                                          | UserRepository, PaymentRepository                                   |
| Controllers            | Singular                                                          | UserController, PaymentController                                   |
| Collections / Wrappers | Plural only if contain multiple items                             | Payments, UserList                                                  |
| Exceptions             | Singular. Should end with `Exception`                             | InvalidPaymentException, UnauthorizedRequestException               |
| DTOs                   | Singular. Plural only if the DTO itself is a collection container | CreateUserRequest, UserResponse, SaleSummaryResponse, SalesResponse |

### API / Endpoints

The project follows the
[RESTful API standard](https://cloud.google.com/discover/what-is-rest-api).

- Every microservice should prefix endpoints with `/api/v1/` (or the
  corresponding version).
- Use **plural resource names** in paths. For example: `/api/v1/users`,
  `/api/v1/sales`.
- Use **HTTP methods to express actions**; avoid verbs in URLs.

#### Standard patterns

| Action        | Method | Endpoint             |
| ------------- | ------ | -------------------- |
| Get all       | GET    | `/api/v1/users`      |
| Get one       | GET    | `/api/v1/users/{id}` |
| Create        | POST   | `/api/v1/users`      |
| Update (full) | PUT    | `/api/v1/users/{id}` |
| Update (part) | PATCH  | `/api/v1/users/{id}` |
| Delete        | DELETE | `/api/v1/users/{id}` |

- Avoid endpoints like `/get-all`, `/add`, `/delete`.
- Use **nouns for resources**, not actions.
- Keep paths **lowercase and `kebab-case`** if needed (`/order-items`).

---

## Project setup

Copy the following files into the project root directory:

- `.env.example`
- `.gitignore`
- `.gitattributes`
- `compose.yml`

Adapt the `.env.example` if is needed (check the `SPRING_APP_NAME` and
`MYSQL_DATABASE` variables).

And also copy the Spring Boot properties files to the corresponding paths:

- `src/main/resources/application.properties`
- `src/main/resources/application-dev.properties`

## 🛠️ Development environment

### Setup the DB container

1. Create a `.env` file from the provided [.env.example](.env.example) and
   modify the settings values accordly. In particular, check the **database
   name**:

   > ```yaml
   > MYSQL_DATABASE=foo
   > ```

2. Start the db container:

   > ```bash
   > docker compose up -d
   > ```

3. Check the db status through the provided **phpmyadmin** service and put the
   defined credentials:
   - Go to [http://localhost:8088](http://localhost:8088)
     - **User:** `user`
     - **Password:** `password`

### Formatter setup

Add the plugin into the project's `pom.xml` file:

<details>
<summary> Click to expand </summary>

```xml
	<build>
		<plugins>
			<plugin>
				<groupId>com.diffplug.spotless</groupId>
				<artifactId>spotless-maven-plugin</artifactId>
				<version>2.43.0</version>
				<configuration>
					<java>
						<licenseHeader>
							<content><![CDATA[/*
								* Copyright © $YEAR DuocUC FullStack 1
								* Eduardo Bray
								* Rodrigo Callealta
								* Fernando Villalobos
								*/
								]]></content>
						</licenseHeader>
						<palantirJavaFormat>
							<version>2.90.0</version>
							<style>PALANTIR</style>
							<formatJavadoc>true</formatJavadoc>
						</palantirJavaFormat>
					</java>
					<formats>
						<format>
							<includes>
								<include>**/*.properties</include>
							</includes>
							<trimTrailingWhitespace />
							<endWithNewline />
						</format>
						<format>
							<includes>
								<include>**/*.md</include>
							</includes>
							<trimTrailingWhitespace />
							<endWithNewline />
						</format>
						<format>
							<includes>
								<include>compose.yml</include>
							</includes>
							<indent>
								<spaces>true</spaces>
								<spacesPerTab>2</spacesPerTab>
							</indent>
							<trimTrailingWhitespace />
							<endWithNewline />
						</format>
						<format>
							<includes>
								<include>pom.xml</include>
								<include>**/*.xml</include>
							</includes>
							<excludes>
								<exclude>**/logback-spring.xml</exclude>
							</excludes>

							<eclipseWtp>
								<type>XML</type>
							</eclipseWtp>
							<indent>
								<tabs>true</tabs>
								<spacesPerTab>4</spacesPerTab>
							</indent>
						</format>
					</formats>
				</configuration>
				<executions>
					<execution>
						<goals>
							<goal>apply</goal>
						</goals>
						<phase>validate</phase>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>
```

</details>

With this, on every project build the source files should be formatted by the
plugin.

#### Manual formatting

Run this to format the codebase through the CLI:

```bash
./mvnw spotless:apply
```

#### IDE

A
[palantir-java-format](https://marketplace.visualstudio.com/items?itemName=szykk1993.palantir-java-format)
plugin/extension is available for VSCode and can be installed to format code on
save.

However, no IDE configuration is required. Formatting is enforced automatically
during the Maven build, ensuring consistent style across all environments.

### Logs

Add the dependency to the `pom.xml` file.

```xml
		<dependency>
			<groupId>net.logstash.logback</groupId>
			<artifactId>logstash-logback-encoder</artifactId>
			<version>7.4</version>
		</dependency>
```

### Exceptions

Check the provided exceptions package. It contains all the needed functionality
to provide project-agnostic exception handling.

Just copy the `src/main/cl/duoc/foo/exception/` package into the project. Adjust
all `foo` to the microservice package name.

### Misc tools

This repository provides some utility scripts that may be useful.

#### Makefile

Copy it into the microservice project root dir and check the available targets
with:

```bash
make help
```

By default (`make`), it starts the containers and the Spring Boot project.

> [!INFO]
>
> This Makefile requires GNU Make to be installed (available by default on WSL).

## 🏗️ Development workflow

The project follows a trunk-based workflow on the `dev` branch. Production ready
code lives in `main`.

### 🔀 Git

#### Repository

- Each microservice should live in its own repository.
- The repository name should follow this style: `foo-api`.
- Each repository should grant write access to all members of the development
  team.

#### Branches

- **dev:** Development branch. All development work and commits should go into
  the `dev` branch.
- **main:** Main branch. **Only production-ready code** should be merged from
  `dev` into the `main` branch.
- Other branches are allowed but should be short-lived (a few days at most).
  Development should mainly happen in the `dev` branch.

#### Commit messages

- The project adheres to the
  [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
  specification.

- Use the format:

  ```
  <type>(<scope>): <subject>
  ```

  For example:

  ```
  feat(UserService): add non-duplicated username validation check
  ```

- Common types:
  - `feat`: new feature
  - `fix`: bug fix
  - `refactor`: code change without behavior change
  - `docs`: documentation only
  - `chore`: maintenance tasks
  - `test`: adding or updating tests

- Keep the **subject line ≤ 72 characters**
  - Use imperative mood (e.g., “add”, not “added”)
  - Do not end with a period
  - Use `&` instead `and`

Optional body allowed but wrap lines at 72 characters. Explain _what_ and _why_,
not _how_.

## Deployment & Production settings

Add the artifact name to the `pom.xml`. This is needed by the `Dockerfile`
script:

```xml
<build>
	<finalName>app-microservice</finalName>
etc ...
```

---

**_Happy codding!_** ☕
