terraform {
    required_version = "1.9.3"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "5.60.0"
        }
    }

    backend "s3" {
        key = "practical-terraform/examples/ec2-for-ssm/terraform.tfstate"
    }
}

provider "aws" {
    region = "us-east-2"
}