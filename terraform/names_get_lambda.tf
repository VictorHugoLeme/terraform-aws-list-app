# Lambda Function
resource "aws_lambda_function" "names_get_handler" {
  function_name = "get_names"

  s3_bucket = "${aws_s3_bucket.lambda_bucket.id}"
  s3_key    = "${aws_s3_object.names_get_handler.key}"

  runtime = "python3.11"
  handler = "get_names.handler"

  source_code_hash = data.archive_file.names_get_handler.output_base64sha256

  role = "${aws_iam_role.names_get_handler_exec.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_ddb_execution" {
  for_each = {
    "cw" = aws_iam_policy.lambda_cloudwatch_exec_policy.arn,
    "ddb" = aws_iam_policy.lambda_ddb_scan_exec_policy.arn
  }

  role       = aws_iam_role.names_get_handler_exec.name
  policy_arn = each.value
}

data "archive_file" "names_get_handler" {
  type        = "zip"
  source_dir  = "../lambdas/get_names"
  output_path = "../get_names.zip"
}

resource "aws_s3_object" "names_get_handler" {
  bucket  = "${aws_s3_bucket.lambda_bucket.id}"
  key    = "get_names.zip"
  source = data.archive_file.names_get_handler.output_path
  etag = filemd5(data.archive_file.names_get_handler.output_path)
}