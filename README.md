[![CHUV](https://img.shields.io/badge/CHUV-LREN-AF4C64.svg)](https://www.unil.ch/lren/en/home.html) [![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://github.com/LREN-CHUV/mip-cde-data-db-setup/blob/master/LICENSE) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/1d9732c8e10646318e9ace662fd83153)](https://www.codacy.com/app/hbp-mip/mip-cde-data-db-setup?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=LREN-CHUV/mip-cde-data-db-setup&amp;utm_campaign=Badge_Grade) [![CircleCI](https://circleci.com/gh/HBPMedical/mip-cde-data-db-setup.svg?style=svg)](https://circleci.com/gh/HBPMedical/mip-cde-data-db-setup)


# MIP CDE database setup

Setup a database with one table containing the Common Data Elements (CDE) defined for MIP.

This project uses [Flyway](http://flywaydb.org/) to manage the database migration scripts that will create and fill the data features tables containing research-grade data used by MIP algorithms for machine learning.

The research-grade data tables can contain the following types of data:

* the features (values) for each Common Data Elements (CDE) defined by MIP.
* the features extracted from research datasets (ADNI, PPMI...)
* the features extracted from clinical data

Here, we create only the `mip_cde_features` table that contains the Common Data Elements of MIP.

The data stored in the feature tables is labelled research-grade as it should have gone through a data curation process (description, registration, adaptation to fit the MIP CDE variables, cleaning...).

## Usage

`mip-cde-data-db` requires a running Postgres database with admin access where it will create new tables and store some data.

Run:

```console
$ docker run -i -t --rm -e FLYWAY_HOST=`hostname` hbpmip/mip-cde-data-db-setup:1.3.1 migrate
```

where the environment variables are:

* FLYWAY_HOST: database host, default to 'db'.
* FLYWAY_PORT: database port, default to 5432.
* FLYWAY_DATABASE_NAME: Optional, name of the database or schema, default to 'data'
* FLYWAY_URL: JDBC url to the database, constructed by default from FLYWAY_DBMS, FLYWAY_HOST, FLYWAY_PORT and FLYWAY_DATABASE_NAME
* FLYWAY_DRIVER: Optional, fully qualified classname of the jdbc driver (autodetected by default based on flyway.url)
* FLYWAY_USER: database user, default to 'data'.
* FLYWAY_PASSWORD: database password, default to 'data'.
* FLYWAY_SCHEMAS: Optional, comma-separated list of schemas managed by Flyway, default to 'public'
* FLYWAY_TABLE: Optional, name of Flyway's metadata table (default: schema_version)
* DATASETS: (deprecated) column-separated list of datasets to load. Each dataset should have a descriptor defined as a Java properties file (\<dataset\>\_dataset.properties) located in /config folder.
* DATAPACKAGE: column-separated list of datapackage.json files to load. This is an alternative method to describing datasets using properties files. Datapackage.json file should be located in the /data folder
* VIEWS: column-separated list of views to create. Each view should have a descriptor defined as a Java properties file (\<view\>\_view.properties) located in /config folder,
  as well as a SQL template whose name is defined with the property \_\_SQL_TEMPLATE and that should be located in the same jar and package.
* AUTO_GENERATE_TABLES: if set to true, will attempt to generate the tables from the datapackage definition. Use this method only for development or quick prototyping, as tables should normally be created using SQL migrations managed by Flyway.
* LOG_LEVEL: desired log level, default is 'info', use 'debug' for more verbose output
* CUSTOM_FEATURES_TABLE: Optional, name of the additional table containing variables not included in the list of MIP Common Data Elements (CDE). A view called mip_local_features will be created that links those additional variables with the MIP CDE variables.

After execution, you should have:

* A table named **mip_cde_features** where the columns match the MIP CDE variables.

## Customizing the data tables

`mip-data-db-setup` provides only the `mip_cde_features` table, you need to customise it to fit your needs.

You can fill this table with prepared data, or create an additional table (and view) that will store additional variables specific to the current site.

You need to create a new project that will contain the following elements:

* a Dockerfile that inherit from hbpmip/data-db-setup
* a set of SQL migration scripts that will create the data tables and views, to be managed by [Flyway](http://flywaydb.org/) and included in the Docker image
* optionally, CSV files containing data to upload into the database if that data is publishable (1)
* a description of the structure of the data tables in the [Frictionlessdata package format](https://frictionlessdata.io/specs/)

You can use the command `atomist create data db setup` from [MIP SDM](https://github.com/LREN-CHUV/mip-sdm) to generate a skeleton of this new project for you.

The Dockerfile for the specialised image should look like:

Dockerfile
```dockerfile
  # Final image
  FROM hbpmip/mip-cde-data-db-setup:1.3.1

  ARG BUILD_DATE
  ARG VCS_REF
  ARG VERSION

  COPY data/mip_cde.csv data/site_vars.csv data/datapackage.json /data/
  COPY sql/V1_3_1__custom_vars.sql /flyway/sql/

  ENV IMAGE=hbpmip/site-data-db-setup:1.0.0 \
      DATAPACKAGE=/data/datapackage.json \
      CUSTOM_FEATURES_TABLE=site_features

```

The following environment variables should be defined statically by child images of mip-cde-data-db-setup:

* IMAGE: name of this Docker image, including version (for help message)
* DATASETS: (deprecated) column-separated list of datasets to load.
* DATAPACKAGE: column-separated list of datapackage.json files to load. This is an alternative method to describing datasets using properties files.
* VIEWS: column-separated list of views to create. Each view should have a descriptor defined as a Java properties file (\<view\>\_view.properties) located in /config folder,
  as well as a SQL template whose name is defined with the property \_\_SQL_TEMPLATE and that should be located in the same jar and package.
* AUTO_GENERATE_TABLES: if set to true, will attempt to generate the tables from the datapackage definition. Use this method only for development or quick prototyping, as tables should normally be created using SQL migrations managed by Flyway.
* CUSTOM_FEATURES_TABLE: Optional, name of the additional table containing variables not included in the list of MIP Common Data Elements (CDE). A view called mip_local_features will be created that links those additional variables with the MIP CDE variables.

Note (1): a Docker image can be seen as a Zip file, it's perfectly reasonable to store data in it, as long as you do not attempt to store several Gigabytes of data. Most Docker images weight a few hundred MB, adding data from CSV files is reasonable.
If the data cannot be published openly, you can rely on private Docker registries such as those provided by [Gitlab.com](https://gitlab.com) that provide a secured and password-protected storage for your Docker image and its data or binaries.

## Build

Run: `./build.sh`

This command will build the Docker image hbpmip/mip-cde-data-db-setup produced by this project

Run: `./build.sh`

## Testing

```
  ./test/test.sh
```

## Publish on Docker Hub

Run: `./publish.sh`

## License

### mip-cde-data-db-setup

(this project)

Copyright (C) 2017 [LREN CHUV](https://www.unil.ch/lren/en/home.html)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

### Flyway

Copyright (C) 2016-2017 [Boxfuse GmbH](https://boxfuse.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

## Trademark
Flyway is a registered trademark of [Boxfuse GmbH](https://boxfuse.com).

# Acknowledgements

This work has been funded by the European Union Seventh Framework Program (FP7/2007­2013) under grant agreement no. 604102 (HBP)

This work is part of SP8 of the Human Brain Project (SGA1).
