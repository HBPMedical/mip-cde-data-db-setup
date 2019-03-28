FROM hbpmip/data-db-setup:2.6.0 as parent-image

# Build stage for quality control
FROM python:3.6.1-alpine as data-qc-env

RUN pip install json-spec

COPY --from=parent-image /schemas/table-schema.schema.json /schemas/
COPY data/mip-cde-table-schema.json /data/
RUN json validate --schema-file=/schemas/table-schema.schema.json < /data/mip-cde-table-schema.json

# Validation of datapackage is not possible here, as no data are packed in mip-cde-data-db-setup image.

FROM hbpmip/data-db-setup:2.6.0

COPY config/env.sh /
COPY config/*.tmpl /tmpl/
COPY data/mip-cde-table-schema.json /data/
COPY sql/V1_0__create.sql \
     sql/V1_1__norm_columns.sql \
     sql/V1_2__fix_typo_columns.sql \
     sql/V1_3__add_proteins.sql \
      /flyway/sql/

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ENV IMAGE=hbpmip/mip-cde-data-db-setup:$VERSION \
    DATAPACKAGE=/data/datapackage.json

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
