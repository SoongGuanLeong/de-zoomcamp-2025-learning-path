FROM python:3.9

RUN apt-get update && apt-get install -y wget
RUN pip install sqlalchemy "dask[dataframe]" psycopg2 pandas

WORKDIR /app
COPY ingest_data.py ingest_data.py

ENTRYPOINT ["python", "ingest_data.py"]