#--------------------------------------------------------------
# This module creates all resources necessary for a public
# subnet
#--------------------------------------------------------------

variable "name" {
  default = "public"
}

variable "vpc_id" {}

variable "cidrs" {
  type    = "list"
  default = []
}

variable "azs" {
  type    = "list"
  default = []
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "igw-${var.name}"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(var.cidrs, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.cidrs)}"

  tags {
    Name = "${var.name}.${element(var.azs, count.index)}"
  }

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = false
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(var.cidrs)}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name = "${var.name}.${element(var.azs, count.index)}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["*"]
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.cidrs)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

output "public_rt" {
  value = "${aws_route_table.public.*.id}"
}

output "gateway_id" {
  value = "${aws_internet_gateway.public.id}"
}

output "subnet_ids" {
  value = "${aws_subnet.public.*.id}"
}
