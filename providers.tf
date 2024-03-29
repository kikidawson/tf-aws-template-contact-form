terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29"
    }
    github = {
      source  = "integrations/github"
      version = "6.1.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      ManagedBy = "terraform"
    }
  }
}

provider "github" {
  owner = "kikidawson"
}
