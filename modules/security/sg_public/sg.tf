variable "sg_name"            {}
variable "vpc_id"             {}
variable "port"               {}
variable "proto"              {default = "tcp"}
variable "source_cidr_blocks" {default = []}

resource "aws_security_group" "security_group" {
  name = "${var.sg_name}"
  description = "Security Group ${var.sg_name}"
  vpc_id = "${var.vpc_id}"
  // allow port for everyone
  ingress {
    from_port = "${var.port}"
    to_port   = "${var.port}"
    protocol  = "${var.proto}"
    cidr_blocks = "${var.source_cidr_blocks}"
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

output "sg_id" {
  value = "${aws_security_group.security_group.id}"
}
