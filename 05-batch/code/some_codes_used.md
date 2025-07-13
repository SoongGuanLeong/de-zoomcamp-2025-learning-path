python3 06_spark_sql.py \
    --input_green=data/pq/green/2020/*/ \
    --input_yellow=data/pq/yellow/2020/*/ \
    --output=data/report-2020

URL="spark://172.31.95.99:7077"

spark-submit \
    --master="$URL" \
    06_spark_sql.py \
        --input_green=data/pq/green/2021/*/ \
        --input_yellow=data/pq/yellow/2021/*/ \
        --output=data/report-2021

--input_green=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/green/2021/*/ \
--input_yellow=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/yellow/2021/*/ \
--output=gs://my-free-tier-16-6-dezoomcamp-bucket/report-2021

gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=northamerica-south1 \
    gs://my-free-tier-16-6-dezoomcamp-bucket/code/06_spark_sql.py \
    -- \
        --input_green=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/green/2020/*/ \
        --input_yellow=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/yellow/2020/*/ \
        --output=gs://my-free-tier-16-6-dezoomcamp-bucket/report-2020


https://cloud.google.com/dataproc/docs/tutorials/bigquery-connector-spark-example#pyspark

dbt_gsoong.reports-2020

gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=northamerica-south1 \
    --jars=gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.37.0.jar \
    --properties=spark.sql.extensions=com.google.cloud.spark.bigquery.BigQuerySparkExtensions \
    gs://my-free-tier-16-6-dezoomcamp-bucket/code/06_spark_sql_bigquery.py \
    -- \
    --input_green=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/green/2020/*/ \
    --input_yellow=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/yellow/2020/*/ \
    --output=my-free-tier-16-6:dbt_gsoong.reports_2020

gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=northamerica-south1 \
    gs://my-free-tier-16-6-dezoomcamp-bucket/code/06_spark_sql_bigquery.py \
    -- \
        --input_green=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/green/2020/*/ \
        --input_yellow=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/yellow/2020/*/ \
        --output=gs://my-free-tier-16-6-dezoomcamp-bucket/report-2019/

#### the bigquery connector didn't work for me so i just use bq load
gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=northamerica-south1 \
    gs://my-free-tier-16-6-dezoomcamp-bucket/code/06_spark_sql_bigquery.py \
    -- \
    --input_green=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/green/2020/*/ \
    --input_yellow=gs://my-free-tier-16-6-dezoomcamp-bucket/pq/yellow/2020/*/ \
    --output=gs://dataproc-temp-northamerica-south1-987883761220-rzavpkph/spark_processed_reports/

bq load --source_format=PARQUET \
    --autodetect \
    my-free-tier-16-6:dbt_gsoong.reports_2020 \
    gs://dataproc-temp-northamerica-south1-987883761220-rzavpkph/spark_processed_reports/*