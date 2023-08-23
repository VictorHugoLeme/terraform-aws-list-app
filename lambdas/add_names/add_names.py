import json
import boto3
import os
from datetime import datetime

sqs_client = boto3.client('sqs')
SQS_QUEUE_NAME = os.environ['SQS_QUEUE_NAME']

def handler(event, context):

  body = json.loads(event['body'])
  name = body['name']


  message = sqs_client.send_message(
    QueueUrl=SQS_QUEUE_NAME,
    MessageBody=json.dumps({
      "name": name,
      "id": datetime.now().isoformat()
      })
    
  )

  return {
    "statusCode": 200,
    "body": json.dumps(message, indent=2)
  }

print(datetime.now().isoformat())