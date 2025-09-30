variable "project_name" { type = string }
variable "common_tags"  { type = map(string) }

# Bot Control の検査レベル：COMMON / TARGETED
variable "bot_inspection_level" {
  type    = string
  default = "COMMON"
}