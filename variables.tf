variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "lambda_name" {
  description = "lambda to monitor"
  type        = string
}

variable "threshold" {
  description = "number of messages that should trigger an alarm"
  type        = number
}