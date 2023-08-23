# Lambda Function
resource "aws_lambda_function" "website_handler" {
  function_name = "get_page_data"

  s3_bucket = "${aws_s3_bucket.lambda_bucket.id}"
  s3_key    = "${aws_s3_object.website_handler.key}"

  runtime = "python3.11"
  handler = "get_page_data.handler"

  source_code_hash = data.archive_file.website_handler.output_base64sha256

  role = "${aws_iam_role.website_handler_exec.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_s3_sqs_execution" {
  for_each = {
    "cw" = aws_iam_policy.lambda_cloudwatch_exec_policy.arn,
    "sqs" = aws_iam_policy.lambda_sqs_exec_policy.arn,
    "s3" = aws_iam_policy.lambda_s3_exec_policy.arn
  }

  role       = aws_iam_role.website_handler_exec.name
  policy_arn = each.value
}

data "archive_file" "website_handler" {
  type        = "zip"
  source_dir  = "../lambdas/get_page_data"
  output_path = "../get_page_data.zip"
}

resource "aws_s3_object" "website_handler" {
  bucket  = "${aws_s3_bucket.lambda_bucket.id}"
  key    = "get_page_data.zip"
  source = data.archive_file.website_handler.output_path
  etag = filemd5(data.archive_file.website_handler.output_path)
}