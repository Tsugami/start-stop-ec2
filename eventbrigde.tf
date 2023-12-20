
resource "aws_scheduler_schedule" "ec2-start-schedule" {
  name                         = "ec2-start-${var.name}"
  schedule_expression_timezone = "America/Sao_Paulo"
  schedule_expression          = var.up_schedule_expression
  description                  = var.up_schedule_description

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = aws_iam_role.scheduler-ec2-role.arn

    input = jsonencode({
      "InstanceIds" : var.instance_ids
    })
  }
}

resource "aws_scheduler_schedule" "ec2-stop-schedule" {
  name                         = "ec2-stop-${var.name}"
  schedule_expression_timezone = "America/Sao_Paulo"
  schedule_expression          = var.down_schedule_expression
  description                  = var.down_schedule_description

  flexible_time_window {
    mode = "OFF"
  }


  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.scheduler-ec2-role.arn

    input = jsonencode({
      "InstanceIds" : var.instance_ids
    })
  }
}