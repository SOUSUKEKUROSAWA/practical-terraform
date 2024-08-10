terraform {
    required_version = "1.9.3"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "5.60.0"
        }
        github = {
            source  = "integrations/github"
            version = "6.2.3"
        }
    }

    backend "s3" {
        key = "practical-terraform/examples/pipeline/terraform.tfstate"
    }
}

provider "aws" {
    region = "us-east-2"
}

provider "github" {
    owner = "SOUSUKEKUROSAWA"
}
