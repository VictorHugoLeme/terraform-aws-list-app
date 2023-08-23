resource "aws_sqs_queue" "names_queue" {
  name = "names-queue"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = "${aws_sqs_queue.names_queue.arn}"
  enabled          = true
  function_name    = "${aws_lambda_function.names_persist_handler.arn}"
  batch_size       = 1
}