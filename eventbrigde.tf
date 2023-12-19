module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus = false

  rules = {
    crons = {
      description         = "Trigger for down EC2"
      schedule_expression = var.down_cron_expression
    }
  }

  targets = {
    crons = [
      {
        name  = "down_ec2"
        arn   = aws_lambda_function.terraform_lambda_func.arn
        input = jsonencode({ "action" : "stop", "instanceIds" : var.instanceIds })
      }
    ]
  }
}
