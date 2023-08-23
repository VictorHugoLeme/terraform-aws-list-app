# Lambda Function
resource "aws_lambda_function" "names_persist_handler" {
  function_name = "persist_names"

  s3_bucket = "${aws_s3_bucket.lambda_bucket.id}"
  s3_key    = "${aws_s3_object.names_persist_handler.key}"

  runtime = "python3.11"
  handler = "persist_names.handler"

  source_code_hash = data.archive_file.names_persist_handler.output_base64sha256

  role = "${aws_iam_role.names_persist_handler_exec.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_sqs_ddb_execution" {
  for_each = {
    "cw"  = aws_iam_policy.lambda_cloudwatch_exec_policy.arn,
    "sqs" = aws_iam_policy.lambda_sqs_receive_policy.arn,
    "ddb" = aws_iam_policy.lambda_ddb_exec_policy.arn
  }
  role       = aws_iam_role.names_persist_handler_exec.name
  policy_arn = each.value
}

data "archive_file" "names_persist_handler" {
  type        = "zip"
  source_dir  = "../lambdas/persist_names"
  output_path = "../persist_names.zip"
}

resource "aws_s3_object" "names_persist_handler" {
  bucket  = "${aws_s3_bucket.lambda_bucket.id}"
  key    = "persist_names.zip"
  source = data.archive_file.names_persist_handler.output_path
  etag = filemd5(data.archive_file.names_persist_handler.output_path)
}