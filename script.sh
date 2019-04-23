#! /bin/bash

set -e
set -x

DOCKER_BIN="/usr/bin/docker"
AS_ID=`docker container ls -qf name=`
YEAR=`date +%Y`
LAST_YEAR=`date '+%Y' --date '1 year ago'`
FROM=""
TO=""



function proposta_to_s3(){
${DOCKER_BIN} cp ${AS_ID}:${FROM}${TO}/proposta
}



