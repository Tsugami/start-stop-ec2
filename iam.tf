data "aws_instance" "ec2" {
  for_each    = toset(var.instance_ids)
  instance_id = each.value
}

resource "aws_iam_policy" "scheduler_ec2_policy" {
  name = "scheduler_ec2_${var.name}_policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "ec2:StartInstances",
            "ec2:StopInstances"
          ],
          "Resource" : [
            for data in data.aws_instance.ec2 : data.arn
          ],
        }
      ]
    }
  )
}

resource "aws_iam_role" "scheduler-ec2-role" {
  name                = "scheduler-ec2-${var.name}-role"
  managed_policy_arns = [aws_iam_policy.scheduler_ec2_policy.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      },
    ]
  })
}