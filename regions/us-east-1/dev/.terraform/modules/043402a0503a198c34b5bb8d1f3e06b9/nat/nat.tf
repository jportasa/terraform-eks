variable "name" {
  default = "nat"
}

variable "azs" {
  type = "list"
  default = []
}

variable "subnet_ids" {
  type = "list"
  default = []
}

resource "aws_eip" "nat" {
  vpc   = true
  count = "${length(var.azs)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat" {
  count         = "${length(var.azs)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index % 3)}"
  subnet_id     = "${element(var.subnet_ids, count.index)}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_eip.nat"]
}

output "nat_gateway_ids" {
  value = "${aws_nat_gateway.nat.*.id}"
}

output "network_interface_ids" {
  value = "${aws_nat_gateway.nat.*.network_interface_id}"
}

output "nat_ips" {
  value = "${aws_eip.nat.*.public_ip}"
}
