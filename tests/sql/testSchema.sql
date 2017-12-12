BEGIN;

-- Plan the tests
SELECT plan( 7 );

SELECT has_table( 'mip_cde_features' );

SELECT has_column( 'mip_cde_features', 'subjectcode' );
SELECT has_column( 'mip_cde_features', 'subjectageyears' );
SELECT has_column( 'mip_cde_features', 'gender' );
SELECT has_column( 'mip_cde_features', 'minimentalstate' );
SELECT has_column( 'mip_cde_features', '_3rdventricle' );
SELECT col_is_pk(  'mip_cde_features', 'subjectcode' );

-- Clean up
SELECT * FROM finish();
ROLLBACK;
