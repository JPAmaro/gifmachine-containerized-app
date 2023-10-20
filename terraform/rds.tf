resource "aws_db_subnet_group" "gifmachine_db" {
  name       = "gifmachine_db_subnet_group"
  subnet_ids = [aws_subnet.gifmachine_subnet_1.id, aws_subnet.gifmachine_subnet_2.id]
}

# RDS instance for gifmachine
resource "aws_db_instance" "gifmachine_db" {
  allocated_storage            = 20
  storage_type                 = "gp3"
  engine                       = "postgres"
  engine_version               = "15"
  instance_class               = "db.t3.micro"
  db_name                      = "gifmachine"
  identifier                   = "db-instance-gifmachine"
  username                     = "gifmachine"
  password                     = aws_ssm_parameter.db_password.value
  skip_final_snapshot          = true
  multi_az                     = false
  performance_insights_enabled = false
  db_subnet_group_name         = aws_db_subnet_group.gifmachine_db.name

  vpc_security_group_ids = [
    aws_security_group.gifmachine_sg.id,
  ]
}