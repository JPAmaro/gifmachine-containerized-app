variable "aws_region" {
  default = "eu-west-1"
}
variable "cluster_name" {
  default = "gifmachine-cluster"
}
variable "gifmachine_ecr" {
  default = "gifmachine-repo"
}
variable "db_password_path" {
  default = "/db_password/gifmachine"
}
variable "database_url_path" {
  default = "/db_url/gifmachine"
}
variable "gifmachine_password_path" {
  default = "/gifmachine_password/gifmachine"
}
variable "gifmachine_api_port" {
  default = 4567
}
variable "gifmachine_db_port" {
  default = 5432
}

variable "aws_access_key" {}
variable "aws_secret_key" {}