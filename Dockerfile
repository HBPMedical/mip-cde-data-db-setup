FROM python:3.6.6-alpine3.8

RUN apk add --no-cache python3-dev build-base
RUN pip3 install goodtables

COPY data/ data/
WORKDIR /data

RUN goodtables validate datapackage.json

FROM hbpmip/data-db-setup:2.5.4

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

COPY config/ /flyway/config/
COPY data/mip-cde-table-schema.json /data/
COPY sql/V1_0__create.sql \
     sql/V1_1__norm_columns.sql \
     sql/V1_2__fix_typo_columns.sql \
     sql/V1_3__add_proteins.sql \
      /flyway/sql/

ENV IMAGE=hbpmip/mip-cde-data-db-setup:$VERSION \
    DATASETS=empty

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="hbpmip/mip-cde-data-db-setup" \
      org.label-schema.description="Setup the table containing the MIP Common Data Elements into a database" \
      org.label-schema.url="https://github.com/LREN-CHUV/mip-cde-data-db-setup" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/LREN-CHUV/mip-cde-data-db-setup" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version="$VERSION" \
      org.label-schema.vendor="LREN CHUV" \
      org.label-schema.license="Apache2.0" \
      org.label-schema.docker.dockerfile="Dockerfile" \
      org.label-schema.schema-version="1.0"
