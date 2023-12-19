variable "aws_region" {
  default = "us-east-1"
}

variable "down_cron_expression" {
  default = "rate(1 minute)"
}

variable "instanceIds" {
  type = list(string)
}
