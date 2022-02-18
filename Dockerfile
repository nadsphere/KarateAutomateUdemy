FROM maven:3.8.4-openjdk-17

WORKDIR /src/app

COPY pom.xml /src/app/
COPY ./src/test/java /src/app/src/test/java

# CMD mvn test

# tapi ga efektif