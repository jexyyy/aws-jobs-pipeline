# AWS Jobs Pipeline: S3, Glue Data Catalog and Athena

A small cloud data pipeline that takes job-posting data produced by my
[Airflow pipeline](https://github.com/jexyyy/airflow-jobs-pipeline), stores it in
Amazon S3, and makes it queryable with SQL through Amazon Athena.

## Architecture

SQLite (Airflow output) -> CSV export -> S3 (raw zone) -> Glue Data Catalog -> Athena

## Steps

1. Exported the `jobs_raw` table from SQLite to CSV with the `sqlite3` CLI.
2. Created an S3 bucket and uploaded the file to `raw/jobs_raw.csv` using the AWS CLI.
3. Created a least-privilege IAM user (S3, Glue, Athena) instead of using the root account.
4. Defined the table explicitly in Athena (see `create_table.sql`).
5. Queried the data with SQL (see `queries.sql`).

## Problems I hit and how I fixed them

**1. Athena "invalid S3 location" error.**
My data bucket was in `ca-central-1`, but Athena was running in `us-east-1`.
Athena needs its query-results bucket in the same region as Athena itself. I
created a results bucket in `us-east-1`.

**2. Header row appeared as data, and quoted commas split fields.**
The Glue crawler named columns `col0` to `col4` and treated the header line as a
data row. Values like "Credit Wellness, LLC" were split into two columns,
shifting everything after them. Because every column is text, the crawler could
not tell the header apart from the data, and the default reader ignored quotes.
Adding a custom classifier did not resolve it, so I replaced the crawler with an
explicit `CREATE EXTERNAL TABLE` using `OpenCSVSerde` and
`skip.header.line.count = 1`.

## Takeaway

Crawlers are useful for exploring unknown data. When the structure is known,
explicit DDL is more reliable and is version-controlled in this repo.

## Files

- `create_table.sql`: table definition
- `queries.sql`: example queries
- `jobs_raw.csv`: sample data exported from the Airflow pipeline

## Tech

AWS S3, AWS Glue Data Catalog, Amazon Athena, IAM, AWS CLI, SQL
