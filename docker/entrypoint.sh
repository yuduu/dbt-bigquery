#! /bin/bash

# Check if ENV Variables Exist
if [ -z ${GITPATH} ]; 
    then echo "ERROR: GITPATH is not set.";
    exit 1; 
fi
if [ -z ${GCP_PROJECT_ID} ]; 
    then echo "ERROR: GCP_PROJECT_ID is not set.";
    exit 1; 
fi
if [ -z ${DBT_DATASET} ]; 
    then echo "ERROR: DBT_DATASET is not set.";
    exit 1; 
fi
if [ -z ${DBT_THREADS} ]; 
    then echo "INFO: DBT_THREADS is not set. Using Default 1";
fi
if [ -z ${DBT_PROJECT} ]; 
    then echo "ERROR: DBT_PROJECT is not set.";
    exit 1; 
fi

# Check if Service Account Keyfile exists
KEYFILE="/tmp/bigquery/keyfile.json"
if [ ! -f "$KEYFILE" ]; then
    echo "ERROR: $KEYFILE does not exist.";
    exit 1;
fi


# Set SSH Key and known_hosts for GIT Repo
SSHPATH=${HOME}/.ssh
mkdir ${SSHPATH}
cp -R /tmp/.ssh ${HOME}/
touch ${SSHPATH}/known_hosts
if [ ! -n "$(grep "^github.com " ${SSHPATH}/known_hosts)" ]; then 
    ssh-keyscan github.com >> ${SSHPATH}/known_hosts 2>/dev/null; 
fi
chmod 700 ${SSHPATH}
chmod 600 ${SSHPATH}/id_rsa


# Cloning Git Repo
# Setting Working Directy
FOLDER="$(echo $GITPATH | sed 's|.*/\(.*\).git|\1|')"
git clone "${GITPATH}"

DBT_PROFILES_DIR="/usr/app/${FOLDER}/dbt"
cd "${DBT_PROFILES_DIR}"

# running dbt

dbt run --project-dir "${DBT_PROFILES_DIR}/${DBT_PROJECT}"


# Synching to GitHub and creating Documentation
dbt docs generate --project-dir "${DBT_PROFILES_DIR}/${DBT_PROJECT}" --no-compile
DBT_DOCS_DIR=${DBT_PROFILES_DIR}/${DBT_PROJECT}/target
mv -f "${DBT_DOCS_DIR}/index.html" "/usr/app/${FOLDER}/docs"
mv -f "${DBT_DOCS_DIR}/manifest.json" "/usr/app/${FOLDER}/docs"
mv -f "${DBT_DOCS_DIR}/target/catalog.json" "/usr/app/${FOLDER}/docs"

git config user.email "you@example.com"
git config user.name "dbt-bigquery-cloud-run"
message="Commit by dbt-bigquery-cloud-run"
git add -A
git commit -a -m "${message}"
git push