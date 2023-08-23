# Website Endpoint Lambda Role
resource "aws_iam_role" "website_handler_exec" {
  name = "website-lambda-role"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF
}

# Website add name Lambda Role
resource "aws_iam_role" "names_handler_exec" {
  name = "names-lambda-role"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF
}

# Website persist name Lambda Role
resource "aws_iam_role" "names_persist_handler_exec" {
  name = "names-persist-lambda-role"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF
}

# Website get names Lambda Role
resource "aws_iam_role" "names_get_handler_exec" {
  name = "names-get-lambda-role"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF
}

resource "aws_iam_policy" "lambda_cloudwatch_exec_policy" {
  name = "lambda-cloudwatch-exec-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement =  [
      {
        Effect= "Allow",
        Action= ["logs:*"],
        Resource= "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_sqs_exec_policy" {
  name = "lambda-sqs-exec-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement =  [
      {
        Effect= "Allow",
        Action= ["sqs:SendMessage*"],
        Resource= "${aws_sqs_queue.names_queue.arn}",
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_ddb_exec_policy" {
  name = "lambda-ddb-exec-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement =  [
      {
        Effect= "Allow",
        Action= ["dynamodb:PutItem"],
        Resource= "${aws_dynamodb_table.names_data.arn}"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_ddb_scan_exec_policy" {
  name = "lambda-ddb-scan-exec-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement =  [
      {
        Effect= "Allow",
        Action= ["dynamodb:Scan"],
        Resource= "${aws_dynamodb_table.names_data.arn}"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_exec_policy" {
  name = "lambda-s3-exec-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement =  [
      {
        Effect= "Allow",
        Action= ["s3:*"],
        Resource= "arn:aws:s3:::*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_sqs_receive_policy" {
  name = "lambda-sqs-receive-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement =  [
      {
        Effect= "Allow",
        Action= [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
          ],
        Resource= "${aws_sqs_queue.names_queue.arn}"
      }
    ]
  })
}