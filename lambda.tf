data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "down_up_ec2" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:Start*",
      "ec2:Stop*"
    ]
    resources = ["*"]
  }

}

resource "aws_iam_role" "lambda" {
  name               = "down_up_ec2_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "lambda" {
  name   = "down_up_ec2_lambda"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.down_up_ec2.json
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/lambda/lambda.zip"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/DownUpEC2"
  retention_in_days = 14
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/lambda/lambda.zip"
  function_name = "DownUpEC2"
  role          = aws_iam_role.lambda.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  depends_on = [aws_iam_role_policy.lambda, aws_cloudwatch_log_group.lambda]
}
