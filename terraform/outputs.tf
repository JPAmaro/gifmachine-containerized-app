output "ecr_repository_url" {
    value = aws_ecr_repository.gifmachine.repository_url
}

output "database_url_parameter" {
    value = aws_ssm_parameter.database_url.name
}

output "gifmachine_password_parameter" {
    value = aws_ssm_parameter.gifmachine_password.name
}

output "account_id" {
    value = data.aws_caller_identity.current.account_id
}

output "ecs_execution_role_arn" {
    value = aws_iam_role.ecs_exec_role.arn
}

output "gifmachine_api_port" {
    value = var.gifmachine_api_port
}

output "gifmachine_cluster" {
    value = aws_ecs_cluster.gifmachine_cluster.name
}

output "gifmachine_cw_log_group" {
    value = aws_cloudwatch_log_group.gifmachine_cluster.name
}