[![CHUV](https://img.shields.io/badge/CHUV-LREN-AF4C64.svg)](https://www.unil.ch/lren/en/home.html) [![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://github.com/LREN-CHUV/mip-cde-data-db-setup/blob/master/LICENSE) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/1d9732c8e10646318e9ace662fd83153)](https://www.codacy.com/app/hbp-mip/mip-cde-data-db-setup?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=LREN-CHUV/mip-cde-data-db-setup&amp;utm_campaign=Badge_Grade) [![CircleCI](https://circleci.com/gh/HBPMedical/mip-cde-data-db-setup.svg?style=svg)](https://circleci.com/gh/HBPMedical/mip-cde-data-db-setup)


# MIP CDE database setup

Setup a database with one table containing the Common Data Elements (CDE) defined for MIP.


## How to build the Docker image

Run: `./build.sh`

# Setup for database 'meta-db' with the selection of variables for mip-cde

## Introduction

This project uses Flyway to manage the database migration scripts for the 'meta-db' database used by MIP.

This database contains the metadata used for reference, including:

* the list of variables and groups for the Common Data Elements (CDE) defined by MIP.
* the list of variables and groups for mip-cde

## Usage

Run:

```console
$ docker run -i -t --rm -e FLYWAY_HOST=`hostname` hbpmip/mip-cde-data-db-setup:0.6.0 migrate
```

where the environment variables are:

* FLYWAY_HOST: database host, default to 'db'.
* FLYWAY_PORT: database port, default to 5432.
* FLYWAY_DATABASE_NAME: name of the database or schema, default to 'meta'
* FLYWAY_URL: JDBC url to the database, constructed by default from FLYWAY_DBMS, FLYWAY_HOST, FLYWAY_PORT and FLYWAY_DATABASE_NAME
* FLYWAY_DRIVER: Fully qualified classname of the jdbc driver (autodetected by default based on flyway.url)
* FLYWAY_USER: database user, default to 'meta'.
* FLYWAY_PASSWORD: database password, default to 'meta'.
* FLYWAY_SCHEMAS: Optional, comma-separated list of schemas managed by Flyway
* FLYWAY_TABLE: Optional, name of Flyway's metadata table (default: schema_version)

## Build

Run: `./build.sh`

## Publish on Docker Hub

Run: `./publish.sh`

## License

Copyright (C) 2017 [LREN CHUV](https://www.unil.ch/lren/en/home.html)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
