# Use the official Gradle image to create a build artifact.
# This is multi-stage build. In the first stage, we build the JAR file.
FROM gradle:7.4.1-jdk17 AS build
WORKDIR /home/gradle/src
COPY --chown=gradle:gradle . /home/gradle/src
RUN gradle build --no-daemon

# In the second stage, we setup the runtime environment and copy the JAR file from the build stage.
FROM openjdk:17-slim
EXPOSE 8080
RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar
ENTRYPOINT ["java","-jar","/app/spring-boot-application.jar"]
