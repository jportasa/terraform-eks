variable "name"            {}
variable "region"          {}
variable "vpc_cidr"        {}
variable "global_cidr"     {}
variable "azs"             {default = []}
variable "private_subnets" {default = []}
variable "public_subnets"  {default = []}
variable "hq_ip"           {default = "0.0.0.0/0"}

module "vpc" {
  source   = "./vpc"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_name = "${var.name}"
}

module "public_subnet" {
  source = "./public_subnet"
  name   = "${var.name}-public"
  vpc_id = "${module.vpc.vpc_id}"
  cidrs  = "${var.public_subnets}"
  azs    = "${var.azs}"
}

module "nat" {
  source     = "./nat"
  name       = "${var.name}-nat"
  azs        = "${var.azs}"
  subnet_ids = "${module.public_subnet.subnet_ids}"
}

module "private_subnet" {
  source          = "./private_subnet"
  name            = "${var.name}-private"
  vpc_id          = "${module.vpc.vpc_id}"
  cidrs           = "${var.private_subnets}"
  azs             = "${var.azs}"
  nat_gateway_ids = "${module.nat.nat_gateway_ids}"
}

module "sg_hq" {
  source            = "../security/sg_hq"
  vpc_id            = "${module.vpc.vpc_id}"
  sg_name           = "sg_hq_vpc_${var.name}"
  source_cidr_block = [
    "${var.hq_ip}",
    "${var.global_cidr}"
  ]
}
# VPC
output "vpc_id"                 {value = "${module.vpc.vpc_id}"}
output "vpc_cidr"               {value = "${module.vpc.vpc_cidr}"}
output "sg_hq_id"               {value = "${module.sg_hq.sg_id}"}
output "main_route_table_id"    {value = "${module.vpc.main_route_table_id}"}
output "default_route_table_id" {value = "${module.vpc.default_route_table_id}"}
# Subnet
output "private_subnet_ids"     {value = "${module.private_subnet.subnet_ids}"}
output "public_subnet_ids"      {value = "${module.public_subnet.subnet_ids}"}
output "private_rt"             {value = "${module.private_subnet.private_rt}"}
output "public_rt"              {value = "${module.public_subnet.public_rt}"}
# GW
output "gateway_id"             {value = "${module.public_subnet.gateway_id}"}
output "nat_gateway_ids"        {value = "${module.nat.nat_gateway_ids}"}
# Nat
output "nat_ips"                {value = "${module.nat.nat_ips}"}