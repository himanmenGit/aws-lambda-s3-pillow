#!/bin/bash

REGION=<REGION-NAME>
FUNCTION_NAME=pil
BUCKET_NAME=<BUCKET-NAME>
S3Key=<KEY-NAME>
CODE=S3Bucket=${BUCKET_NAME},S3Key=${S3Key}
ROLE=<arn:aws:iam::123456789:role/role-name>
HANDLER=pil.handler_func
RUNTIME=python3.6
TIMEOUT=60
MEMORY_SIZE=512
ENV="Variables={PYTHONPATH=/var/task/src:/var/task/lib}"
PROFILE=<PROFILE-NAME>


make make-pil-s3-upload


aws lambda create-function \
--region ${REGION} \
--function-name ${FUNCTION_NAME} \
--code ${CODE} \
--role ${ROLE} \
--handler ${HANDLER} \
--runtime ${RUNTIME} \
--timeout ${TIMEOUT} \
--memory-size ${MEMORY_SIZE} \
--environment ${ENV} \
--profile ${PROFILE}
