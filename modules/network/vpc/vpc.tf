#--------------------------------------------------------------
# This module creates all resources necessary for a VPC
#--------------------------------------------------------------

variable "vpc_name" { default = "" }
variable "vpc_cidr" { default = "10.0.0.0/16" }

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags      { Name = "vpc-${var.vpc_name}" }
  lifecycle { create_before_destroy = true }
}

resource "aws_default_route_table" "default_rtb" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags {
    Name = "${var.vpc_name}-main-rtb"
  }
  depends_on = ["aws_vpc.vpc"]
}

output "vpc_id"   { value = "${aws_vpc.vpc.id}" }
output "vpc_cidr" { value = "${aws_vpc.vpc.cidr_block}" }
output "main_route_table_id" { value = "${aws_vpc.vpc.main_route_table_id }" }
output "default_route_table_id" { value = "${aws_vpc.vpc.default_route_table_id}" }