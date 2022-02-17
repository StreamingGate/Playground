FROM openjdk:11-jdk
RUN apt-get update && apt upgrade -y \
    && apt-get install -y ffmpeg \
    && ffmpeg -version
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-Dcom.amazonaws.sdk.disableEc2Metadata=true","-Dspring.profiles.active=develop", "-Dserver.port=50006", "-jar","/app.jar"]