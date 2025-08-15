FROM openjdk:17-alpine
WORKDIR /app
RUN apk add --no-cache curl && \
    curl -u admin:'!Keep0ut!' -O "http://65.1.108.247:31020/repository/java-artifact/myapp/myapp-1.0.war"
ENTRYPOINT ["java", "-jar", "/app/myapp.war"]

