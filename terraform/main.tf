# ECR Repository for gifmachine
resource "aws_ecr_repository" "gifmachine" {
  name         = var.gifmachine_ecr
  force_delete = true
}

# VPC, Subnet, Security Group, and related networking resources
resource "aws_vpc" "gifmachine_vpc" {
  cidr_block = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "gifmachine_subnet_1" {
  vpc_id            = aws_vpc.gifmachine_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "gifmachine_subnet_2" {
  vpc_id            = aws_vpc.gifmachine_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_security_group" "gifmachine_sg" {
  vpc_id = aws_vpc.gifmachine_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.gifmachine_api_port
    to_port     = var.gifmachine_api_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.gifmachine_db_port
    to_port     = var.gifmachine_db_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.gifmachine_vpc.cidr_block]
  }
}

resource "aws_internet_gateway" "base_igw" {
  vpc_id = aws_vpc.gifmachine_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.gifmachine_vpc.id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_rt.id
  gateway_id             = aws_internet_gateway.base_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.gifmachine_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.gifmachine_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

data "aws_caller_identity" "current" {}
