#!/usr/bin/env python
# coding: utf-8
import argparse
import dask.dataframe as dd
import os

from time import time
from sqlalchemy import create_engine

FILE_NAME = "output.parquet"

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url
    
    CONN_STR = f'postgresql://{user}:{password}@{host}:{port}/{db}'
    engine = create_engine(CONN_STR)
    
    # download the parquet file
    os.system(f"wget {url} -O {FILE_NAME}")
    
    ddf = dd.read_parquet(FILE_NAME)

    ddf.head(0).to_sql(name=table_name, con=engine, if_exists='replace', index=False)

    print("Schema inserted successfully.")

    engine.dispose()

    ddf.map_partitions(load_chunk_data, con_str=CONN_STR, table_name=table_name).compute()

    print("Bulk data insertion completed.")


def load_chunk_data(df_partition, con_str, table_name):
    local_engine = None
    try:
        local_engine = create_engine(con_str)

        # df_partition['tpep_pickup_datetime'] = pd.to_datetime(df_partition['tpep_pickup_datetime'], errors='coerce')
        # df_partition['tpep_dropoff_datetime'] = pd.to_datetime(df_partition['tpep_dropoff_datetime'], errors='coerce')

        start_time = time()
        df_partition.to_sql(name=table_name, con=local_engine, if_exists='append', index=False)
        end_time = time()
        print(f"Inserted chunk of {len(df_partition)} rows in {end_time - start_time:.2f}s.")
    except Exception as e:
        print(f"Error inserting chunk: {e}")
    finally:
        local_engine.dispose()


if __name__ == "__main__":
    # user, password, host, port , database_name, table_name, url of the file
    parser = argparse.ArgumentParser(description="Ingest parquet data to postgres")

    parser.add_argument('--user', help='username for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='db name for postgres')
    parser.add_argument('--table_name', help='name of the table in db in postgres')
    parser.add_argument('--url', help='url of parquet file')

    args = parser.parse_args()
    
    main(args)