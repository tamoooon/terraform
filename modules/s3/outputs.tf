# modules/s3/outputs.tf

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}

# モジュール側で使うなら有効化
output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}
