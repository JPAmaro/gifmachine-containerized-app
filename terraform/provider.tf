provider "aws" {
	region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 5.21"
		}

		null = {
			source = "hashicorp/null"
			version = "~> 3.2"
		}

		tls = {
			source = "hashicorp/tls"
			version = "~> 4.0"
		}

		random = {
			source = "hashicorp/random"
			version = "~> 3.5"
		}
	}
}