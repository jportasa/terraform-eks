#--------------------------------------------------------------
# This module creates all resources necessary for a private
# subnet
#--------------------------------------------------------------

variable "name" {
  default = "private"
}

variable "vpc_id" {}

variable "cidrs" {
  type = "list"
  default = []
}

variable "azs" {
  type = "list"
  default = []
}

variable "nat_gateway_ids" {
  type = "list"
  default = []
}

resource "aws_subnet" "private" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(var.cidrs, count.index)}"
  availability_zone = "${element(var.azs, count.index % 3)}"
  count             = "${length(var.cidrs)}"

  tags {
    Name = "${var.name}.${element(var.azs, count.index)}.${lower(count.index)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(var.cidrs)}"

  tags {
    Name = "${var.name}.${element(var.azs, count.index)}.${lower(count.index)}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["*"]
  }
}

resource "aws_route" "private_nat_gateway" {
  count                  = "${length(var.cidrs)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(var.nat_gateway_ids, count.index % 3)}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.cidrs)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

output "private_rt" {
  value = "${aws_route_table.private.*.id}"
}

output "subnet_ids" {
  value = "${aws_subnet.private.*.id}"
}
