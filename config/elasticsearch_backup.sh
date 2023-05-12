#!/bin/sh

FILE=`date +"%Y-%m-%d-%H_%M"`${FILE_SUFFIX}.tar.gz
OUTPUT_FILE=/backups/${FILE}

mkdir -p /backups
ssh -oStrictHostKeyChecking=no -o ExitOnForwardFailure=yes -f -L 9200:localhost:${ES_PORT} ${SSH_USERNAME}@${SSH_HOST} -p ${SSH_PORT} sleep 10
elasticdump --input=http://${ES_USERNAME}:${ES_PASSWORD}@localhost:9200/  --output=/backups/data.json --type=data --size=5000
ssh -oStrictHostKeyChecking=no -o ExitOnForwardFailure=yes -f -L 9200:localhost:${ES_PORT} ${SSH_USERNAME}@${SSH_HOST} -p ${SSH_PORT} sleep 10
elasticdump --input=http://${ES_USERNAME}:${ES_PASSWORD}@localhost:9200/  --output=/backups/mapping.json --type=mapping --size=5000

tar -czvf $OUTPUT_FILE /backups/data.json /backups/mapping.json
rm /backups/data.json /backups/mapping.json

echo "${OUTPUT_FILE} was created:"
ls -l ${OUTPUT_FILE}

find $BACKUP_DIR -maxdepth 1 -mtime +$DAYS_TO_KEEP -name "*${FILE_SUFFIX}.tar.gz" -exec rm -rf '{}' ';'
