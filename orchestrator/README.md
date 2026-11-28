# Orquestador de Microservicios FullStack

Este repositorio orquesta el despliegue de los microservicios (Spring Boot), una
base de datos MySQL y phpMyAdmin utilizando Docker Compose.

<!--toc:start-->

- [Orquestador de Microservicios FullStack](#orquestador-de-microservicios-fullstack)
  - [Inicio rápido (TL;DR)](#inicio-rápido-tldr)
  - [Distribución de servicios y puertos](#distribución-de-servicios-y-puertos)
  - [Despliegue (Deploy)](#despliegue-deploy)
    - [1. Configuración de red](#1-configuración-de-red)
    - [2. Aprovisionamiento de instancias](#2-aprovisionamiento-de-instancias)
      - [Instancia backend](#instancia-backend)
      - [Instancia frontend](#instancia-frontend)
    - [3. Levantar servicios](#3-levantar-servicios)
  - [Comandos Make disponibles](#comandos-make-disponibles)
  - [Arquitectura de base de datos](#arquitectura-de-base-de-datos)

<!--toc:end-->

## Inicio rápido (TL;DR)

Ejecutar el siguiente comando para clonar los repositorios, generar el script de
inicialización de la base de datos, construir las imágenes y levantar los
contenedores:

```bash
make run
```

- **Swagger UI:** Todos los microservicios tienen su API documentada con swagger
  disponible en `/swagger-ui/index.html` a través de sus respectivos puertos
  expuestos.
- **Acceso a la Base de Datos:** Se puede revisar la base de datos completa del
  proyecto mediante **phpMyAdmin** en `http://localhost:8088`. Usar las
  credenciales **user** y **password**.

## Distribución de servicios y puertos

Este es el mapa actual de los puertos que utiliza cada servicio:

| Servicio                   | Puerto externo (Host) | Puerto interno (Contenedor) | Descripción                                          |
| :------------------------- | :-------------------- | :-------------------------- | :--------------------------------------------------- |
| **Eureka Service**         | `8123`                | `8123`                      | Eureka                                               |
| **API Gateway**            | `8080`                | `8080`                      | API gateway del proyecto.                            |
| **Auth API**               | `8000`                | `8080`                      | Microservicio de autenticación                       |
| **Users API**              | `8001`                | `8080`                      | Microservicio de usuarios                            |
| **Sales API**              | `8002`                | `8080`                      | Microservicio de ventas                              |
| **Invoice API**            | `8003`                | `8080`                      | Microservicio de facturación                         |
| **Carts API**              | `8004`                | `8080`                      | Microservicio de carritos                            |
| **Product API**            | `8005`                | `8080`                      | Microservicio de productos                           |
| **Pets API**               | `8006`                | `8080`                      | Microservicio de mascotas                            |
| **Appointments API**       | `8007`                | `8080`                      | Microservicio de citas                               |
| **Vets API**               | `8008`                | `8080`                      | Microservicio de veterinarios                        |
| **Store Manager API**      | `8009`                | `8080`                      | Microservicio de gestión de tienda                   |
| **Accounting Manager API** | `8010`                | `8080`                      | Microservicio de gestión contable                    |
| **Vet Manager API**        | `8011`                | `8080`                      | Microservicio de gestión veterinaria                 |
| **MySQL DB**               | `3306`                | `3306`                      | Base de datos MySQL principal que aloja los esquemas |
| **phpMyAdmin**             | `8088`                | `80`                        | Interfaz web para la base de datos MySQL             |

## Despliegue (Deploy)

A continuación se encuentran las instrucciones para desplegar una demo de la
aplicación en AWS EC2:

### 1. Configuración de red

1. Crear un **Security Group** con las siguientes reglas:
   - **Inbound (Entrada):**
     - **Frontend:** Custom TCP, puerto `4173`, origen `0.0.0.0/0`
     - **Backend:** Custom TCP, puerto `8080`, origen `0.0.0.0/0`
     - **Base de datos:** Custom TCP, puerto `8088`, origen `0.0.0.0/0`
     - **Administración:** SSH, puerto `22`, origen `0.0.0.0/0`
   - **Outbound (Salida):**
     - Todo el tráfico (All traffic), puerto `All`, destino `0.0.0.0/0`
2. Asignar **2 Elastic IPs** y tomar nota de ambas direcciones (una para el
   backend y otra para el frontend).

### 2. Aprovisionamiento de instancias

Crear un _Launch Template_ (o configurar cada instancia directamente) usando las
especificaciones que se detallan a continuación. Adjuntar el **Security Group**
creado en el paso 1 a cada una y de la misma forma asociar una **Elastic IP** a
cada instancia tras iniciarlas.

#### Instancia backend

- **Tipo de instancia:** `t3.large` (8 GB RAM)
- **Almacenamiento:** 24 GB
- **OS:** Ubuntu Server
- **Script de inicialización (User data):**

  ```bash
  #!/usr/bin/env bash
  set -euo pipefail

  apt-get update -y
  apt-get install -y make git

  curl -fsSL https://get.docker.com | sh
  usermod -aG docker ubuntu

  su - ubuntu -c "git clone -b for-frontend https://github.com/polirritmico/springboot-layout.git /home/ubuntu/springboot-layout"
  ```

#### Instancia frontend

- **Tipo de instancia:** `t3.medium` (4 GB RAM)
- **Almacenamiento:** 24 GB
- **OS:** Ubuntu Server
- **Script de inicialización (User data):**

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

### 3. Levantar servicios

1. **Desplegar el backend:** Conectarse a la instancia del backend e iniciar los
   servicios usando la Elastic IP del **frontend** para CORS:

   ```bash
   ssh ubuntu@<backend-public-ip> -i jkiltro.pem
   cd springboot-layout/orchestrator
   CORS_ALLOWED_ORIGINS="http://<frontend-public-ip>:4173" make deploy
   ```

> [!NOTE]
>
> El arranque del backend tarda alrededor de 10-15 minutos (?!) en completarse.

2. **Desplegar el frontend:** Conectarse a la instancia del frontend, configurar
   la Elastic IP del **backend**, compilar y levantar el servidor preview:
   ```bash
   ssh ubuntu@<frontend-public-ip> -i jkiltro.pem
   cd fullstack-frontend && cp .env.development .env
   export VITE_JKILTRO_API="http://<backend-public-ip>:8080" && npm run build
   nohup npm run preview -- --host 0.0.0.0 > frontend.log 2>&1 &
   disown
   ```

> _¡Está vivo!_

Revisar el sitio en el navegador entrando a `http://<frontend-public-ip>:4173`.
También, se puede revisar la base de datos a través del contenedor de
**phpMyAdmin** expuesto en `http://<backend-public-ip>:8088`.

---

## Comandos Make disponibles

- `make run`: Comando completo para clonar, generar scripts, construir y
  ejecutar en primer plano
- `make deploy`: Similar a run, pero define la política de reinicio a siempre
  para deploys persistentes (ejecuta en segundo plano).
- `make detached`: Ejecuta los contenedores en segundo plano (detached)
- `make stop`: Detiene los contenedores activos sin borrar los datos
- `make clean`: Limpieza (teardown). Detiene contenedores, elimina volúmenes y
  scripts de inicialización
- `make clean-full`: Limpieza profunda. También elimina los repositorios
  clonados
- `make setup`: Prepara el espacio de trabajo (clona repos y genera el
  `init.sql`)
- `make build`: Compila las imágenes Docker de todos los servicios (ejecuta
  `setup` automáticamente)
- `make clone`: Clona todos los repositorios de servicios requeridos
- `make db-init`: Genera el script de inicialización de la base de datos
- `make help`: Muestra la lista de comandos disponibles

## Arquitectura de base de datos

Se levanta un único contenedor MySQL para toda la red. Para garantizar el
aislamiento, el `Makefile` crea dinámicamente un script de inicialización basado
en los repositorios activos. Este script aprovisiona un esquema de base de datos
separado y dedicado para cada microservicio al arrancar mediante un volumen
nombrado de Docker (`mysql_init_volume`).
