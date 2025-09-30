# modules/s3/variables.tf

variable "bucket_name"   { type = string }
variable "project_name"  { type = string }
variable "common_tags"   { type = map(string) }