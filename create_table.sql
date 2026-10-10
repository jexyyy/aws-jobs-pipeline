CREATE EXTERNAL TABLE jobs_pipeline_db.jobs_clean (
  title string,
  company_name string,
  location string,
  salary string,
  posted_at string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '"',
  'escapeChar' = '\\'
)
LOCATION 's3://hadjer-jobs-pipeline-2026/raw/'
TBLPROPERTIES ('skip.header.line.count' = '1');
