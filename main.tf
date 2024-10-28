resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "${var.name_prefix}-lambda-error-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = var.threshold
  alarm_description   = "Alarm when the Lambda function has errors"
  dimensions = {
    FunctionName = var.lambda_name
  }

  alarm_actions = [aws_sns_topic.error_alarm_topic.arn]
}

data "aws_ssm_parameter" "slack_webhook_url" {
  name = "/config/slack/webhooks/alerts"
}

resource "aws_sns_topic" "error_alarm_topic" {
  name = "${var.name_prefix}-error-count-alarms"
}

module "alarms_to_slack" {
  source      = "github.com/nsbno/terraform-aws-alarms-to-slack?ref=3b8197b"
  name_prefix = var.name_prefix
  slack_webhook_urls = [
    data.aws_ssm_parameter.slack_webhook_url.value,
  ]
  sns_topic_arns = [
    aws_sns_topic.error_alarm_topic.arn
  ]
}