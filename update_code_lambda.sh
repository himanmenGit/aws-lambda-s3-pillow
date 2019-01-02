#!/bin/bash

FUNCTION_NAME=myThumbnailFunc
ZIP_FILE=fileb://pil.zip
BUCKET=<BUCKET-NAME>
KEY=pil.zip
PROFILE=<PROFILE-NAME>

make make-pil-s3-upload


aws lambda update-function-code \
--function-name ${FUNCTION_NAME} \
--s3-bucket ${BUCKET} \
--s3-key ${KEY} \
--profile ${PROFILE}