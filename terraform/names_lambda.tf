# Lambda Function
resource "aws_lambda_function" "names_handler" {
  function_name = "add_names"

  s3_bucket = "${aws_s3_bucket.lambda_bucket.id}"
  s3_key    = "${aws_s3_object.names_handler.key}"

  runtime = "python3.11"
  handler = "add_names.handler"

  source_code_hash = data.archive_file.names_handler.output_base64sha256

  role = "${aws_iam_role.names_handler_exec.arn}"

  environment {
    variables = {
      SQS_QUEUE_NAME = aws_sqs_queue.names_queue.url
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_sqs_execution" {
  for_each = {
    "cw" = aws_iam_policy.lambda_cloudwatch_exec_policy.arn,
    "sqs" = aws_iam_policy.lambda_sqs_exec_policy.arn
  }

  role       = aws_iam_role.names_handler_exec.name
  policy_arn = each.value
}

data "archive_file" "names_handler" {
  type        = "zip"
  source_dir  = "../lambdas/add_names"
  output_path = "../add_names.zip"
}

resource "aws_s3_object" "names_handler" {
  bucket  = "${aws_s3_bucket.lambda_bucket.id}"
  key    = "add_names.zip"
  source = data.archive_file.names_handler.output_path
  etag = filemd5(data.archive_file.names_handler.output_path)
}