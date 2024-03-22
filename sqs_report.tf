resource "aws_sqs_queue" "report_request_queue" {
    name                      = "report-request"
    delay_seconds             = 10
    max_message_size          = 2048
    message_retention_seconds = 86400
    receive_wait_time_seconds = 10
  
}


data "aws_iam_policy_document" "reportreq_sqs_policy" {
  statement {
    sid    = "reportreqsqsstatement"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.report_request_queue.arn
    ]
  }
}

resource "aws_sqs_queue_policy" "reportreq_sqs_policy" {
  queue_url = aws_sqs_queue.report_request_queue.id
  policy    = data.aws_iam_policy_document.reportreq_sqs_policy.json
}