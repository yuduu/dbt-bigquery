##
#  Generic dockerfile for dbt image building.
#  See README for operational details
##



# base image (abstract)
##
FROM python:3.10.5-alpine3.16 as base

# Env vars
ENV PYTHONIOENCODING=utf-8 \
    LANG=C.UTF-8 \ 
    USER=dbt

# System setup
RUN apk add --no-cache \
    git \
    libpq \
    openssh \
  && addgroup dbt \
  && adduser \
    --disabled-password \
    --ingroup "$USER" \
    "$USER" \
  && mkdir /usr/app/ \
  && chown -R dbt:dbt /usr/app/
  # Added dbt user and Group



##
# dbt-bigquery
##
FROM base as dbt-bigquery

# Change User
USER dbt
ENV PATH="${HOME}/.local/bin:${PATH}"
WORKDIR /usr/app/
# Install Bigquery
RUN python -m pip install \
    --upgrade pip setuptools wheel \
    --no-cache-dir \
  && python -m pip install \
    -Iv --no-cache-dir \
    dbt-bigquery==1.2.0

# Change entry workdir

WORKDIR "/usr/app/${FOLDER}"
#VOLUME /usr/app/${FOLDER}
# Volume for GitHub.com SSH Repo Key (private)
VOLUME /tmp/.ssh
VOLUME /tmp/bigquery
CMD ["sh", "-c"]


