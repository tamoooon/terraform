# modules/lambda_schedule/main.tf

resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-ec2-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-lambda-role"
    }
  )
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_name}-lambda-ec2-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ec2:StartInstances", "ec2:StopInstances"],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# Lambda for stopping EC2
resource "aws_lambda_function" "stop_instance" {
  filename         = "${path.module}/stop_instance.zip"
  function_name    = "${var.project_name}-stop-ec2"
  role             = aws_iam_role.lambda_role.arn
  handler          = "stop_instance.lambda_handler"
  runtime          = "python3.10"
  source_code_hash = filebase64sha256("${path.module}/stop_instance.zip")

  environment {
    variables = {
      INSTANCE_ID = var.ec2_instance_id
      REGION      = var.region
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-lambda-stop-instance"
    }
  )
}

# Lambda for starting EC2
resource "aws_lambda_function" "start_instance" {
  filename         = "${path.module}/start_instance.zip"
  function_name    = "${var.project_name}-start-ec2"
  role             = aws_iam_role.lambda_role.arn
  handler          = "start_instance.lambda_handler"
  runtime          = "python3.10"
  source_code_hash = filebase64sha256("${path.module}/start_instance.zip")

  environment {
    variables = {
      INSTANCE_ID = var.ec2_instance_id
      REGION      = var.region
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-lambda-start-instance"
    }
  )
}

# Stop every day at 23:00 JST (14:00 UTC)
resource "aws_cloudwatch_event_rule" "stop_schedule" {
  name                = "${var.project_name}-stop-ec2-schedule"
  schedule_expression = "cron(0 14 * * ? *)"
}

# Start every day at 09:00 JST (0:00 UTC)
resource "aws_cloudwatch_event_rule" "start_schedule" {
  name                = "${var.project_name}-start-ec2-schedule"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_schedule.name
  target_id = "StopEC2"
  arn       = aws_lambda_function.stop_instance.arn
}

resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_schedule.name
  target_id = "StartEC2"
  arn       = aws_lambda_function.start_instance.arn
}

resource "aws_lambda_permission" "stop_permission" {
  statement_id  = "AllowEventBridgeStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_instance.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_schedule.arn
}

resource "aws_lambda_permission" "start_permission" {
  statement_id  = "AllowEventBridgeStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_instance.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_schedule.arn
}
