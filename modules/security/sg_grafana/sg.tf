variable "sg_name"           {}
variable "vpc_id"            {}
variable "source_cidr_block" {default = []}

resource "aws_security_group" "security_group" {
    name = "${var.sg_name}"
    description = "Security Group ${var.sg_name}"
    vpc_id = "${var.vpc_id}"

    // allow bitbucket ingress
    ingress {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"
        cidr_blocks = "${var.source_cidr_block}"
    }
    // allow bitbucket ingress
    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = "${var.source_cidr_block}"
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
