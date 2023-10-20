resource "null_resource" "iam_wait" {
  depends_on = [
    aws_iam_role.ec2,
    aws_iam_role_policy_attachment.ec2,
    aws_iam_instance_profile.ec2
  ]
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

locals {
  user_data_template = templatefile("${path.module}/user-data/cluster.tpl",
  {
    cluster_name = aws_ecs_cluster.gifmachine_cluster.name
  }
  )
}

resource "aws_launch_template" "gifmachine" {
    image_id      = data.aws_ami.amazon_linux_2.image_id
    user_data     = base64encode(local.user_data_template)
    instance_type = "t2.micro"

    iam_instance_profile {
      name = aws_iam_instance_profile.ec2.name
    }

    network_interfaces {
      associate_public_ip_address = true
      security_groups = [aws_security_group.gifmachine_sg.id]
      delete_on_termination = true
    }
}

resource "aws_autoscaling_group" "gifmachine" {
    name                      = "asg-${var.cluster_name}"
    vpc_zone_identifier       = [aws_subnet.gifmachine_subnet_1.id, aws_subnet.gifmachine_subnet_2.id]

    launch_template {
      id      = aws_launch_template.gifmachine.id
      version = aws_launch_template.gifmachine.latest_version
    }

    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "EC2"

    tag {
      key                 = "Name"
      value               = "gifmachine"
      propagate_at_launch = true
    }
}

# ECS Cluster for gifmachine
resource "aws_ecs_cluster" "gifmachine_cluster" {
  name = var.cluster_name

  depends_on = [null_resource.iam_wait]
}

# Cluster Log Group
resource "aws_cloudwatch_log_group" "gifmachine_cluster" {
  name = "/ecs/${var.cluster_name}"
}