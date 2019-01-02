clean:
	rm -rf pil pil.zip
	rm -rf __pycache__

fetch-dependencies:
	mkdir -p lib/

build-pil-package: clean fetch-dependencies
	mkdir pil
	cp -r src pil/.
	cp -r lib pil/.
	pip install -r requirements.txt -t pil/lib/.
	cp -r ./env/lib/python3.6/site-packages/PIL pil/lib/.
	cd pil; zip -9qr pil.zip .
	cp pil/pil.zip .
	rm -rf pil
	rm -rf lib

BUCKET_NAME=<BUCKET-NAME>
PROFILE=<PROFILE-NAME>

make-pil-s3-upload: build-pil-package
	aws s3 cp pil.zip s3://${BUCKET_NAME} --profile ${PROFILE}