variable "env" {}

variable "region" {}
variable "zone_id" {}

variable "global_cidr" {
  default = "10.0.0.0/8"
}

variable "aws_account_id" {
  default = "953835556803"
}

provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "exercici-dev-terraform"
    key    = "dev.tfstate"
    region = "us-east-1"
  }
}

