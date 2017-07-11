# Build stage for statistics
FROM python:3.6.1-alpine as build-stats-env

COPY sql/values.csv /data/values.csv

RUN pip install --no-cache-dir csvkit==1.0.2 \
    && csvstat /data/values.csv > /data/values.stats

# Recover the jar from the parent image
FROM hbpmip/data-db-setup:1.0.2 as parent-image

# Build stage for Java classes
FROM maven:3.5.0-jdk-8-alpine as build-java-env

COPY --from=parent-image /usr/share/jars/setup-data.jar /flyway/jars/
COPY src/main/java/ /project/src/

WORKDIR /project/src
RUN jar uvf /flyway/jars/setup-data.jar -C . .

# Final image
FROM hbpmip/data-db-setup:1.0.2

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

COPY --from=build-stats-env /data /data
COPY --from=build-java-env /flyway/jars/setup-data.jar /flyway/jars/setup-data.jar
COPY sql/create.sql /flyway/sql/V1_0__create.sql
COPY docker/run.sh /

RUN chmod +x /run.sh

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="hbpmip/mip-cde-data-db-setup" \
      org.label-schema.description="Research database setup using the MIP Common Data Elements" \
      org.label-schema.url="https://github.com/LREN-CHUV/mip-cde-data-db-setup" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/LREN-CHUV/mip-cde-data-db-setup" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version="$VERSION" \
      org.label-schema.vendor="LREN CHUV" \
      org.label-schema.license="Apache2.0" \
      org.label-schema.docker.dockerfile="Dockerfile" \
      org.label-schema.schema-version="1.0"
