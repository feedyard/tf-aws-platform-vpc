terraform {
  required_version = "= 0.11.11"
}

provider "aws" {
  version = "~> 1.57"
  region  = "${var.cluster_aws_region}"
}

variable "cluster_name" {}

variable "cluster_vpc_name" {}
variable "cluster_aws_region" {}

variable "cluster_azs" {
  type = "list"
}

variable "cluster_cidr_reservation_start" {}
variable "cluster_enable_nat_gateway" {}
