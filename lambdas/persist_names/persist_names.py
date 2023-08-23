import json
import boto3

dynamo = boto3.client('dynamodb')
DDB_TABLE_NAME = "NamesData"

def handler(event, context):
  for record in event['Records']:

    
    payload = json.loads(record["body"])
    print(payload["name"])
    try:
      dynamo.put_item(
        TableName=DDB_TABLE_NAME,
        Item={
          "id": {
            "S": payload["id"]
          },
          "name": {
            "S": payload["name"]
          }
        }
      )
      print()
    except Exception as e:
      print(e)

    
    