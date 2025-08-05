FROM openjdk:17-alpine
WORKDIR /app
RUN apk add --no-cache curl && \
    curl -u admin:'!Keep0ut!' -O "http://13.203.219.176:31020/repository/artifact-repo/myapp/myapp-1.0.war"
ENTRYPOINT ["java", "-jar", "/app/myapp.war"]
