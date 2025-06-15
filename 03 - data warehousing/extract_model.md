## Model deployment
[Tutorial](https://cloud.google.com/bigquery-ml/docs/export-model-tutorial)
### Steps
- gcloud auth login
- bq --project_id my-free-tier-12-6 extract -m zoomcamp.tip_model gs://my-free-tier-12-6-taxi-ml-model/tip_model
- mkdir tmp/model/
- gsutil cp -r gs://my-free-tier-12-6-taxi-ml-model/tip_model "C:/Users/ASUS/Desktop/03 - data warehousing/tmp/model/"
- mkdir -p serving_dir/tip_model/1
- cp -r tmp/model/tip_model/* serving_dir/tip_model/1
- docker pull tensorflow/serving
- docker run -p 8501:8501 -v "${PWD}\serving_dir\tip_model:/models/tip_model" -e MODEL_NAME=tip_model tensorflow/serving
- curl -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' -X POST http://localhost:8501/v1/models/tip_model:predict
- http://localhost:8501/v1/models/tip_model