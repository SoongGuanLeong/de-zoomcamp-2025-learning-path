-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `my-free-tier-12-6.zoomcamp.external_homework`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://my-free-tier-12-6-homework/yellow_tripdata_2024-*.parquet']
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE my-free-tier-12-6.zoomcamp.homework_non_partitioned AS
SELECT * FROM my-free-tier-12-6.zoomcamp.external_homework;

--  count the distinct number of PULocationIDs
SELECT COUNT(DISTINCT(PULocationID)) FROM my-free-tier-12-6.zoomcamp.external_homework;
SELECT COUNT(DISTINCT(PULocationID)) FROM my-free-tier-12-6.zoomcamp.homework_non_partitioned;

-- How many records have a fare_amount of 0?
SELECT COUNT(1) 
FROM my-free-tier-12-6.zoomcamp.external_homework
WHERE fare_amount=0;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE my-free-tier-12-6.zoomcamp.homework_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM my-free-tier-12-6.zoomcamp.external_homework;

-- distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15
SELECT DISTINCT(VendorID) FROM my-free-tier-12-6.zoomcamp.homework_non_partitioned
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' and '2024-03-15';

SELECT DISTINCT(VendorID) FROM my-free-tier-12-6.zoomcamp.homework_partitioned_clustered
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' and '2024-03-15';

-- SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read?
SELECT COUNT(*) FROM my-free-tier-12-6.zoomcamp.homework_non_partitioned;





