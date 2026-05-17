# Arquitectura

El backend de nuestra aplicación está dividido en 4 dominios principales:

- Dominio de sistema: Usuarios, Auth
- Dominio de tienda: Carrito, Productos
- Dominio clínico: Consultas, Mascotas, Veterinarios
- Dominio contable: Boletas/Facturas, Ventas (productos o servicios)

La arquitectura sigue un enfoque de **microservicios de dominio** orquestados
por una capa de aplicación (_managers_).

<img width="1994" height="1600" alt="architecture_v1" src="https://github.com/user-attachments/assets/e6ad8770-021e-465f-bfa1-4fae5c6693e4" />

A continuación el detalle de cada uno:

## Dominio clínico

Agrupa todo lo relacionado con el negocio clínico del aplicativo. Desde el
agendamiento de consultas y datos de mascotas, hasta el registro de contratos de
veterinarios.

A continuación el detalle de cada microservicio:

### Microservicio Pets (Mascotas)

Registro de mascotas-pacientes. No contiene lógica clínica, sino datos de
identificación y el manejo animal tales como nombre, peso, especie, raza,
dimensiones, indicación si es dócil, fecha nacimiento, sexo, etc.

Modelos principales:

- Mascota
- Raza
- Especie

### Microservicio Veterinarians (Veterinarios)

Gestiona los veterinarios desde la perspectiva clínica y administrativa,
perfiles profesionales, definición de turnos (horario de entrada y salida),
datos legales del profesional para emisión de documentos como firma, título,
especialidad, etc.

Modelos principales:

- Veterinario
- Horarios
- Especialidad

### Microservicio Appointments (Citas y consultas)

Núcleo operacional del dominio. Gestiona el agendamiento de las horas así como
el registro de las consultas. Revisa e informa de los bloques de tiempo
ocupados, cruza los turnos de los médicas y citas ya reservadas para informar
disponibilidad, etc.

Modelos principales:

- Consultas: Tabla que registra las consultas incluyendo la mascota, usuario y
  el veterinario implicados, así como también las prescripciones médicas.
- Prescripciones: Detalles de medicamentos y tratamiento asociados a una
  consulta.
- Citas: Maneja horarios, actores (mascota, veterinario, usuario) y estados de
  consulta (pendiente, cancelada, realizada, confirmada, etc.)

### Microservicio VetManager (Orquestador)

Actúa como fachada del dominio clínico exponiendo los de casos de uso al resto
del sistema mediante una API basada en intenciones
([modelo RESTful intent-based](https://dzone.com/articles/rest-api-design-intent-api-pattern)).
Se encarga de la orquestación técnica, transformación de DTO. No almacena estado
ni lógica interna de dominio. Extrae el user_id del Bearer token y lo propaga a
los microservicios internos correspondientes.

Solicita los turnos a `Veterinarians` y solicita a `Appointments` pasándole los
turnos, para que los cruce internamente con las citas agendadas de la BD y
retornar los bloques de horario disponibles de vuelta al `VetManager` que envía
la respuesta al front.

## Dominio de sistema

El principio más importante de diseño para mantener ambos servicios desacoplados
es que **Auth** se encargue de manejar los contextos de seguridad mientras
**Users** se encarga de manejar las entidades de dominio. La única interfaz de
conexión entre ambos debe ser el identificador único que se transporta en el
token.

### Microservicio Auth

Un "cuartel" aislado de seguridad. No le interesa la lógica de negocio, se
encarga exclusivamente de la validación de accesos y la emisión de tokens.

Modelos principales:

- RefreshToken: Gestiona la vigencia y revocación de las sesiones activas.
- Credentials: Datos de ingreso y verificación necesarios para validar la
  cuenta.

### Microservicio User

Plantea al usuario como entidad fundamental del negocio. Se centra en quién es
el usuario dentro del sistema de la aplicación.

Modelos principales:

- User: Entidad de negocio con los datos de identidad de los usuarios,
  información de contacto y atributos del perfil.

---

## Contenerización

Esta es la configuración de la red interna de los microservicios. Este modelo se
replica en cada instancia:
