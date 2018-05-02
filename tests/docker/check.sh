#!/bin/bash

# Generate the tests cheking the presence of all columns defined in the list of variables defined
# in the metadata (hierarchy.json in meta table)

vars="$(PGPASSWORD=$META_PASSWORD psql -h $META_HOST -p $META_PORT -d $META_DATABASE -U $META_USER --tuples-only -c "SELECT hierarchy FROM meta_variables;")"

cat <<EOF > /test/testSchemaSync.sql
BEGIN;

-- Plan the tests
SELECT plan( 1 );

SELECT columns_are(
    'public',
    'mip_cde_features',
    ARRAY[
     'subjectcode',
EOF

echo "$vars" | jq --raw-output '[(.. | .variables? | .[]? | ("!" + .code + "!") )] | sort | join(",")' | tr "!" "'" >> /test/testSchemaSync.sql

cat <<EOF >> /test/testSchemaSync.sql
   ]
);

-- Clean up
SELECT * FROM finish();
ROLLBACK;
EOF

source /test.sh
