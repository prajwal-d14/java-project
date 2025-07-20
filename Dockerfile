FROM ubuntu AS builder
RUN apt update
RUN apt install maven -y && mvn -version
RUN apt install git -y && git --version
RUN apt install openjdk-17-jdk -y && java -version
WORKDIR /app
RUN git clone https://github.com/prajwal-d14/myapp.git
WORKDIR /app/myapp
RUN JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 mvn clean install

FROM alpine/java:17-jdk
COPY --from=builder /app/myapp/target/myapp-1.0.war /app/myapp.war
WORKDIR /app
ENTRYPOINT ["java", "-jar", "/app/myapp.war"]
EXPOSE 8080

