# AWS lambda와 s3를 이용한 썸네일 만들기 기본 코드

* `Pillow` 라이브러리 `_imaging` 에러 관련 패키징 방법 - <https://learn-serverless.org/post/deploying-pillow-aws-lambda/>

## `Makefile` 

>`lambda`함수를 만들거나 업데이트를 하기 위한 파일 패키징 및 도커 테스트 쉘 스크립트


`clean` - 패키징 파일 삭제

`fetch-dependencies` - 패키징 하기 전 필요한 라이브러리 폴더및 파일 추가 

`build-pil-package` - `clean` `fetch-dependencies` 를 실행하고 프로젝트를 패키징

`make-pil-s3-upload` - `build-pil-package` 를 실행후 s3에 업로드
	
	
## `create_lambda.sh`
* 람다 함수를 만들기 위한 스크립트
 
```
#!/bin/bash
REGION=<리전>
FUNCTION_NAME=<람다 함수 이름>
BUCKET_NAME=<버켓 네임>
S3Key=<버켓에 올라간 람다프로젝트 패키지 이름>
CODE=S3Bucket=${BUCKET_NAME},S3Key=${S3Key}
ROLE=<AWS에 역화>
HANDLER=<람다 함수의 진입점 핸들러 이름>
RUNTIME=python3.6
TIMEOUT=60
MEMORY_SIZE=512
ENV="Variables={PYTHONPATH=/var/task/src:/var/task/lib}"
PROFILE=<자신의 로컬 ~/aws/credential에 저장된 프로필 이름>

# 패키징하여 s3에 업로드
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
```

## `update_code_lambda.sh`
* 람다함수코드를 업데이트 하기 위한 스크립트

``` 
#!/bin/bash
FUNCTION_NAME=<람다 함수 이름>
ZIP_FILE=<람다 패키지 파일>(fileb://pil.zip)
BUCKET=<버켓 네임>
KEY=<파일 이름>
PROFILE=<프로필 네임>

# 패키징하여 s3에 업로드
make make-pil-s3-upload


aws lambda update-function-code \
--function-name ${FUNCTION_NAME} \
--s3-bucket ${BUCKET} \
--s3-key ${KEY} \
--profile ${PROFILE}
```