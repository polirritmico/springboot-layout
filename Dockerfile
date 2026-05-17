FROM eclipse-temurin:25-jdk-jammy AS build
WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline
COPY src ./src
RUN ./mvnw clean package

FROM eclipse-temurin:25-jre-alpine AS production
WORKDIR /app
ARG ARTIFACT_NAME
COPY --from=build /app/target/${ARTIFACT_NAME}.jar app-microservice.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app-microservice.jar"]
