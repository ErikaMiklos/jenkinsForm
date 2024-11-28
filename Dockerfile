# Étape de construction
FROM maven:3.8.1-openjdk-11-slim AS build
WORKDIR /app

# Copier les fichiers de configuration Maven
COPY pom.xml .
COPY src ./src

# Construire l'application
RUN mvn clean package -DskipTests=true

# Étape finale
FROM openjdk:11-jre-slim
WORKDIR /app

# Créer un répertoire pour les données persistantes
RUN mkdir -p /app/data

# Copier le jar construit
COPY --from=build /app/target/*.jar app.jar

# Configuration du point d'entrée
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# Documentation du port exposé
EXPOSE 8080

# Définir un volume pour la persistance
VOLUME ["/app/data"]

USER jenkins
