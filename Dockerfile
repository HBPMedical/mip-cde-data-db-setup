FROM hbpmip/data-db-setup:2.5.1

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

COPY config/ /flyway/config/
COPY data/ /data/
COPY sql/V1_0__create.sql \
     sql/V1_1__norm_columns.sql \
     sql/V1_2__fix_typo_columns.sql \
     sql/V1_3__add_proteins.sql \
      /flyway/sql/

ENV IMAGE=hbpmip/mip-cde-data-db-setup:$VERSION \
    DATASETS=empty

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
