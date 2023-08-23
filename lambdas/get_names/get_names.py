import json
import boto3

dynamo = boto3.resource('dynamodb')
DDB_TABLE_NAME = "NamesData"

table = dynamo.Table(DDB_TABLE_NAME)

def handler(event, context):
  items = table.scan()
  response = {
    "statusCode": 200,
    "body": json.dumps(items, indent=2),
    "headers": {
      "Content-Type": "application/json"
    }
  }
  return response
  
