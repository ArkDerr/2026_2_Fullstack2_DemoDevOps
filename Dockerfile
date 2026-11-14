# ETAPA 1: BUILD
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B dependency:go-offline
COPY src ./src
RUN mvn -B clean package -DskipTests

# ETAPA 2: RUNTIME
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Directorio en el que H2 guardara el archivo de la base de datos.
RUN mkdir -p /app/data && chown -R 10001:10001 /app/data
COPY --from=build /app/target/*.jar app.jar
ENV DB_DIR=/app/data
USER 10001
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]