BEGIN;

-- Plan the tests
SELECT plan( 6 );

SELECT has_table( 'merged_data' );

SELECT has_column( 'merged_data', 'subjectcode' );
SELECT has_column( 'merged_data', 'subjectageyears' );
SELECT has_column( 'merged_data', 'gender' );
SELECT has_column( 'merged_data', 'minimentalstate' );
SELECT col_is_pk(  'merged_data', 'subjectcode' );

-- Clean up
SELECT * FROM finish();
ROLLBACK;
