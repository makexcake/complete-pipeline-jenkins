FROM openjdk:8-jdk-alpine

EXPOSE 8080

RUN mkdir /opt/app

COPY bootcamp-java-mysql-project-$BUILD_VERSION.jar /opt/app

WORKDIR /opt/app

CMD ["java", "-jar", "bootcamp-java-mysql-project-$BUILD_VERSION.jar"]
