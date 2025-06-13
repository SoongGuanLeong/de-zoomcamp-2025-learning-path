```powershell
docker run -it `
  -e POSTGRES_USER="root" `
  -e POSTGRES_PASSWORD="root" `
  -e POSTGRES_DB=ny_taxi `
  -v C:/Users/ASUS/Desktop/docker/ny_taxi_postgres_data:/var/lib/postgresql/data `
  -p 5432:5432 `
  --name ny_taxi_postgres `
  postgres:13
```
```powershell
pgcli -h localhost -p 5432 -u root -d ny_taxi
```

* [NY TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
* [Yellow Trips Data Dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)
* [Taxi Zone Lookup Table](https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv)

```powershell
docker run -it `
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" `
  -e PGADMIN_DEFAULT_PASSWORD="root" `
  -p 8080:80 `
  dpage/pgadmin4
```

## network
```powershell
docker network create pg-network
```
```powershell
docker run -it `
  -e POSTGRES_USER="root" `
  -e POSTGRES_PASSWORD="root" `
  -e POSTGRES_DB=ny_taxi `
  -v C:/Users/ASUS/Desktop/docker/ny_taxi_postgres_data:/var/lib/postgresql/data `
  -p 5432:5432 `
  --name pg-database `
  --network=pg-network `
  postgres:13
```
```powershell
docker run -it `
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" `
  -e PGADMIN_DEFAULT_PASSWORD="root" `
  -p 8080:80 `
  --name pgadmin `
  --network=pg-network `
  dpage/pgadmin4
```

```powershell
$URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2019-10.parquet"

python ingest_data.py `
  --user=root `
  --password=root `
  --host=localhost `
  --port=5432 `
  --db=ny_taxi `
  --table_name=green_taxi_trips `
  --url="$URL"
```

```powershell
docker build -t taxi_ingest:v001 .
```

```powershell
docker run -it `
  --network=pg-network `
  taxi_ingest:v001 `
    --user=root `
    --password=root `
    --host=pg-database `
    --port=5432 `
    --db=ny_taxi `
    --table_name=yellow_taxi_trips `
    --url="$URL"
```
