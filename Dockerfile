ARG USERNAME
ARG PASSWORD
ARG NEXUS_URL
FROM openjdk:17-alpine
WORKDIR /app
RUN apk add --no-cache curl && \
    curl -u ${USERNAME}:${PASSWORD} -o myapp.war ${NEXUS_URL}
ENTRYPOINT ["java", "-jar", "/app/myapp.war"]
