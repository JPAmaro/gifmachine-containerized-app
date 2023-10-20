resource "random_string" "db_password" {
  length  = 20
  special = false
}

resource "random_string" "gifmachine_password" {
  length  = 20
  special = false
}

resource "aws_ssm_parameter" "db_password" {
  name   = var.db_password_path
  type   = "SecureString"
  value  = random_string.db_password.result
  key_id = "alias/aws/ssm" # Default AWS managed key for Parameter Store
}

resource "aws_ssm_parameter" "database_url" {
  name   = var.database_url_path
  type   = "SecureString"
  value  = "postgres://${aws_db_instance.gifmachine_db.username}:${aws_db_instance.gifmachine_db.password}@${aws_db_instance.gifmachine_db.endpoint}/${aws_db_instance.gifmachine_db.db_name}"
  key_id = "alias/aws/ssm" # Default AWS managed key for Parameter Store
}

resource "aws_ssm_parameter" "gifmachine_password" {
  name   = var.gifmachine_password_path
  type   = "SecureString"
  value  = random_string.gifmachine_password.result
  key_id = "alias/aws/ssm" # Default AWS managed key for Parameter Store
}