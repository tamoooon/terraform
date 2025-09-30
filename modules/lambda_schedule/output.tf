# modules/lambda_schedule/output.tf

output "start_lambda_name" {
  value = aws_lambda_function.start_instance.function_name
}

output "stop_lambda_name" {
  value = aws_lambda_function.stop_instance.function_name
}
