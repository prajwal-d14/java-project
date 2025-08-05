ARG NEXUS_USER
ARG NEXUS_PASS
ARG NEXUS_URL
FROM openjdk:17-alpine
WORKDIR /app
RUN apk add --no-cache curl && \
    curl -u ${NEXUS_USER}:${NEXUS_PASS} -o myapp.jar ${NEXUS_URL}
ENTRYPOINT ["java", "-jar", "/app/myapp.war"]



