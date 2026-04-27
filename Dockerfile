FROM openjdk:17-jre-slim
COPY target/cicd-demo-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
