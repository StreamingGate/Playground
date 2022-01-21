FROM openjdk:11-jdk
RUN apt-get update && apt-get install -y iputils-ping
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-Dspring.profiles.active=develop", "-jar","/app.jar"]