# spotbq

# Install GCP SDK

See: https://cloud.google.com/sdk/docs/quickstart-linux

Recipe:

    wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-231.0.0-linux-x86_64.tar.gz
    tar xf google-cloud-sdk-231.0.0-linux-x86_64.tar.gz
    ./google-cloud-sdk/install.sh
    gcloud components update
    gcloud init

# Grab spotbq

    git clone https://github.com/udhos/spotbq
    cd spotbq

# Create table

    export PROJECT_ID=projectid
    export DATASET=datasetname
    export TABLE=tablename
    export DRY= ;# set for DRY run

    bq mk --dataset $PROJECT_ID:$DATASET
    bq mk --table $PROJECT_ID:$DATASET.$TABLE schema.json

# Run spotbq.sh

    export PROJECT_ID=projectid
    export DATASET=datasetname
    export TABLE=tablename
    export DRY= ;# set for DRY run

    ./spotbq.sh

# bq References

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

