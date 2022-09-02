# Example Usage
```bash
#! /bin/bash

docker run \
    -it \
    -v /home/yuduu/.ssh:/tmp/.ssh:ro \
    -v /home/yuduu/.gcp:/tmp/bigquery:ro \
    -e "GITPATH=${GITPATH}" \
    -e "GCP_PROJECT_ID=$GCP_PROJECT_ID}" \
    -e "DBT_DATASET=${DBT_DATASET}" \
    -e "DBT_PROJECT=${DBT_PROJECT}" \
    --rm \
    yuduu/dbt-bigquery \
    sh
```