-- Preview the data
SELECT * FROM jobs_pipeline_db.jobs_clean LIMIT 5;

-- Postings per company
SELECT company_name, COUNT(*) AS postings
FROM jobs_pipeline_db.jobs_clean
GROUP BY company_name
ORDER BY postings DESC;
