variable "aws_region" {
  default = "us-east-1"
}

variable "instance_ids" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "up_schedule_expression" {
  type = string
}

variable "up_schedule_description" {
  type = string
}

variable "down_schedule_description" {
  type = string
}

variable "down_schedule_expression" {
  type = string
}