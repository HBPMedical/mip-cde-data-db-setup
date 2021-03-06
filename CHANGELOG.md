
# Changelog

## 1.4.0 - 2018-09-27

* Define mip-cde-table-schema.json for the MIP CDEs
* Generate mip_local_features view when environment variable CUSTOM_FEATURES_TABLE is defined
* Update to data-db-setup 2.5.5

## 1.3.0 - 2018-08-18

* Update to data-db-setup 2.4.0, configuration moved to /flyway/config inside the Docker image

## 1.2.0 - 2018-05-02

* Typo in neurodegenerativescategories variable
* Add t-tau, p-tau and B-amyloid variables as CDEs
* Add columns for proteins, sync with mip-cde-meta 1.3.1
* Test that CDE fields are in sync with meta

## 1.1.0 - 2017-12-12

* Rename 3rdventricle to _3rdventricle and 4thventricle to _4thventricle

## 1.0.0 - 2017-08-17

* First stable version of this setup, based on data-db-setup version 2.1.0. We will ensure smooth upgrades from now on.

## 0.7.0 - 2017-08-10

* Remove all CLM-specific variables

## 0.6.0 - 2017-07-21

* Replace subjectagemonths by subjectage to match ADNI
