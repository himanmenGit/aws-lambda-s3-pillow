import urllib.parse
import boto3
import uuid
from PIL import Image

# aws내에서는 서비스 끼리 명시적인 credential이 없어도 호출이 가능 하다.
s3_client = boto3.client('s3')


# 이미지 사이즈 반으로 리사이즈
def resize_image(image_path, resized_path):
    with Image.open(image_path) as image:
        image.thumbnail(tuple(x / 2 for x in image.size))
        image.save(resized_path)


# 람다가 호출할 함수
# 등록한 버킷에 파일이 올라가면 람다함수가 트리거 되면서 event에 해당 정보가 담겨 옴.
def handler_func(event, context):
    try:
        for record in event['Records']:
            # 버켓 네임을 받음
            bucket = record['s3']['bucket']['name']
            # 파일 Key를 받음
            key = record['s3']['object']['key']

            # 람다함수는 /tmp/에만 파일을 쓸 수 있다.
            download_path = '/tmp/{}{}'.format(uuid.uuid4(), key)
            upload_path = '/tmp/resized-{}'.format(key)

            # 한글 파일명을 위한 디코딩
            decode_key = urllib.parse.unquote(key)
            # himanmen-aws-lambda-thumbnail에서 파일을 받아
            s3_client.download_file(bucket, decode_key, download_path)

            # 리사이징 후
            resize_image(download_path, upload_path)

            # himanmen-aws-lambda-thumbnail-resized로 파일을 업로드
            # ACL을 퍼블릭으로 메타데이터는 image/jpeg로
            s3_client.upload_file(upload_path, '{}-resized'.format(bucket), key,
                                  ExtraArgs={'ACL': 'public-read', 'ContentType': 'image/jpeg'})
    except Exception as e:
        print(e)
