
if [ -n "$CUSTOM_FEATURES_TABLE" ]; then
  mkdir -p /flyway/config/
  dockerize -template /tmpl/mip_local_features_view.properties.tmpl:/flyway/config/mip_local_features_view.properties

  if [ -z "$VIEWS" ]; then
    export VIEWS=mip_local_features
  elif [[ ! "$VIEWS" =~ "mip_local_features" ]]; then
    export VIEWS=mip_local_features,$VIEWS
  fi

  # Should elegantly deal with cases such as:
  # - a clinical dataset built with mip-cde-data version 1.3 + a custom table created at version 1.3.1 is applied on a database,
  #   then a research dataset built with mip-cde-data version 1.3 is applied on the same database
  # - a clinical dataset built with mip-cde-data version 1.3 + a custom table created at version 1.3.1 is applied on a database,
  #   then some time later the same dataset is re-built with mip-cde-data version 1.4 + the re-generation of the custom table at version 1.4.1
  export FLYWAY_IGNORE_FUTURE_MIGRATIONS=true
  export FLYWAY_IGNORE_MISSING_MIGRATIONS=true
fi
