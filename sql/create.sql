SET datestyle to 'European';

CREATE TABLE MERGED_DATA
(
  CONSTRAINT pk_merged_data PRIMARY KEY (subjectcode)
)
WITH (
  OIDS=FALSE
);
