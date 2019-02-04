variable "sg_name" {}
variable "vpc_id" {}

variable "source_sg" {
  type    = "list"
  default = []
}

variable "source_cidr" {
  type    = "list"
  default = []
}

variable "dest_sg" {
  type    = "list"
  default = []
}

resource "aws_security_group" "security_group" {
  name        = "${var.sg_name}"
  description = "Security Group ${var.sg_name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${var.source_sg}"]
    cidr_blocks     = ["${var.source_cidr}"]
  }

  egress {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = ["${var.dest_sg}"]
  }

}

output "sg_id" {
  value = "${aws_security_group.security_group.id}"
}
