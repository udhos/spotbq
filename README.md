# spotbq

List datasets:

    bq ls --project_id PROJECT_ID

Create dataset:

    bq mk --dataset PROJECT_ID:DATASET

List tables:

    bq ls PROJECT_ID:DATASET

Create table:

    bq mk --table PROJECT_ID:DATASET.TABLE schema.json

Show table:

    bq show PROJECT_ID:DATASET.TABLE

Show head:

    bq head --max_rows=10 PROJECT_ID:DATASET.TABLE

Delete table:

    bq rm -t PROJECT_ID:DATASET.TABLE

Query:

    bq query --nouse_legacy_sql 'select * from `PROJECT_ID.DATASET.TABLE` limit 100'

Insert:

    bq load --source_format=CSV PROJECT_ID:DATASET.TABLE data.csv schema.json

Delete data:

    bq query --nouse_legacy_sql 'delete from `PROJECT_ID.DATASET.TABLE` where true'

