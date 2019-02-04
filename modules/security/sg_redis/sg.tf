variable "sg_name"           {}
variable "vpc_id"            {}
variable "source_cidr" { type = "list", default = []}

resource "aws_security_group" "security_group" {
    name = "${var.sg_name}"
    description = "Security Group ${var.sg_name}"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 6379
        to_port   = 6479
        protocol  = "tcp"
        cidr_blocks = ["${var.source_cidr}"]
    }

    lifecycle {
      create_before_destroy = true
    }
}

output "sg_id" {
  value = "${aws_security_group.security_group.id}"
}
