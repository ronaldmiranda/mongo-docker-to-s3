#!/bin/bash
#
# Backup a mongoDB database inside container to s3 mount storage.
#
set -x 

DOCKER_BIN="/usr/bin/docker"
MONGO_CONTAINER=prod_mongo
BACKUP_DIR=test.gz
BACKUP_S3=/mnt/senai40-maturidade
DAYS_TO_KEEP=7
FILE_SUFFIX=_senai40_backup.gz
DATABASE=senai40-prod
USER=postgres

FILE=`date +"%Y-%m-%d"`${FILE_SUFFIX}

OUTPUT_FILE=${BACKUP_DIR}/${FILE}
SEND_TO_S3=${BACKUP_S3}/${FILE}

# do the database backup (dump)
# use this command for a database server on localhost. add other options if need be.
${DOCKER_BIN} exec -it ${MONGO_CONTAINER} bash -c "mongodump --db ${DATABASE} --archive=/${BACKUP_DIR} --gzip"

# Use this command to copy from docker container to S3 Storage:
docker cp ${MONGO_CONTAINER}:/${BACKUP_DIR} ${BACKUP_S3}/${FILE}

# gzip the mysql database dump file
#/bin/gzip $OUTPUT_FILE
#/bin/gzip $SEND_TO_S3

# show the user the result
echo "${OUTPUT_FILE}.gz was created:"
#ls -l ${OUTPUT_FILE}.gz

# show the user the result
echo "${SEND_TO_S3}.gz was created:"
#ls -l ${SEND_TO_S3}.gz

# prune old backups
find $BACKUP_S3 -mindepth 1 -maxdepth 1 -type f -iname '*.gz' -printf "%C+ %p\n" | sort -n | cut -d ' ' -f 2- | head -n -${DAYS_TO_KEEP} | xargs -I{} rm "{}"
#find $BACKUP_S3 -mindepth 1 -maxdepth 1 -type f -iname '*.gz' -printf "%C+ %p\n" | sort -n | cut -d ' ' -f 2- | head -n -${DAYS_TO_KEEP} | xargs -I{} rm "{}"
