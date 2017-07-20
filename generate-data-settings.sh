#!/bin/bash

# Generates the configuration settings starting from variables.json file

variables_file=$1
target_table="mip_cde_features"
dataset="my_data"

if ! [ -f "$variables_file" ] ; then
  echo "Generates the configuration settings starting from variables.json file"
  echo "Usage:"
  echo "  ./generate-data-settings.sh ../mip-cde-meta-db-setup/variables.json"
  echo "Please run this script from the root of your data project."
  exit 1
fi

echo

mkdir -p src/main/java/eu/humanbrainproject/mip/migrations/

cat << EOF > src/main/java/eu/humanbrainproject/mip/migrations/columns.properties
# suppress inspection "UnusedProperty" for whole file

# Name of the dataset
__DATASET=$dataset
# Name of the target table
__TABLE=$target_table
# CSV file containing the data to inject in the table
__CSV_FILE=/data/values.csv
# Columns of the table
__COLUMNS=$(cat $variables_file | jq  --raw-output '[(.. | .variables? | .[]? | .code)] | sort | join(",")' )
# SQL statement to remove all data from a previous execution
__DELETE_SQL=DELETE FROM $target_table WHERE dataset='$dataset'

# Description of the type and constraints for each column in the table
subjectcode.type=char(20)
subjectcode.is_index=true
EOF

cat $variables_file | jq --raw-output '
  def char_type(v):
    if (v|has("length")) then
      "char(" + (v.length|tostring) + ")"
    else
      "varchar(256)"
    end
  ;
  .. | .variables? | .[]? | ( .code + ".type=" + (if has("sql_type") then
    .sql_type
  elif .type == "real" then
    "numeric"
  elif .type == "integer" then
    "int"
  elif .type == "binominal" then
    char_type(.)
  elif .type == "polynominal" then
    char_type(.)
  else
    char_type(.)
  end))' | sort >> src/main/java/eu/humanbrainproject/mip/migrations/columns.properties

echo "Generated src/main/java/eu/humanbrainproject/mip/migrations/columns.properties"

mkdir -p sql/

cat << EOF > sql/create.sql
SET datestyle to 'European';

CREATE TABLE $target_table
(
    "subjectcode" char(20),
EOF

cat $variables_file | jq --raw-output '
  def char_type(v):
    if (v|has("length")) then
      "char(" + (v.length|tostring) + ")"
    else
      "varchar(256)"
    end
  ;
  .. | .variables? | .[]? | ( "    !" + .code + "! " + (if has("sql_type") then
    .sql_type
  elif .type == "real" then
    "numeric"
  elif .type == "integer" then
    "int"
  elif .type == "binominal" then
    char_type(.)
  elif .type == "polynominal" then
    char_type(.)
  else
    char_type(.)
  end) + ",")' | tr "!" '"' | sort >> sql/create.sql

cat << EOF >> sql/create.sql

    CONSTRAINT pk_$target_table PRIMARY KEY (subjectcode)
)
WITH (
    OIDS=FALSE
);
EOF

echo "Generated sql/create.sql"

cat $variables_file | jq  --raw-output '[(.. | .variables? | .[]? | .code)] | sort | join(",")' > sql/values.csv

echo "Generated sql/values.csv"
