import boto3
s3_client = boto3.client('s3')

S3_BUCKET_NAME = 'victor-website-assets-bucket'

def handler(event, context):
    object_key = "index.html"
    file_content = s3_client.get_object(
        Bucket=S3_BUCKET_NAME, Key=object_key)["Body"].read()
    print(file_content)

    response = {
        "statusCode": 200,
        "body": file_content,
        "headers": {
            'Content-Type': 'text/html',
        }
    }

    return response