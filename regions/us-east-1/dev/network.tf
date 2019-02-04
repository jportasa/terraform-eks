variable "vpc_name" {}
variable "vpc_cidr" {}

variable "vpc_private_subnets" {
  type    = "list"
  default = []
}


variable "vpc_azs" {
  type    = "list"
  default = []
}

module "network" {
  source          = "../../../modules/network"
  region          = "${var.region}"
  name            = "${var.vpc_name}"
  vpc_cidr        = "${var.vpc_cidr}"
  private_subnets = "${var.vpc_private_subnets}"
  azs             = "${var.vpc_azs}"
  global_cidr     = "${var.global_cidr}"
}


# VPC
output "vpc_name" {
  value = "${var.vpc_name}"
}

output "vpc_id" {
  value = "${module.network.vpc_id}"
}

output "vpc_cidr" {
  value = "${module.network.vpc_cidr}"
}

output "main_route_table_id" {
  value = "${module.network.main_route_table_id}"
}

output "private_rt" {
  value = "${module.network.private_rt}"
}


# Subnets
output "private_subnet_ids" {
  value = "${module.network.private_subnet_ids}"
}

# GW
output "gateway_id" {
  value = "${module.network.gateway_id}"
}

output "nat_gateway_ids" {
  value = "${module.network.nat_gateway_ids}"
}

# Nat
output "nat_ips" {
  value = "${module.network.nat_ips}"
}
