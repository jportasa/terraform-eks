
variable "sg_name" {
  description = "The name for the security group"
}

variable "vpc_id" {
  description = "The VPC this security group will go in"
}

variable "source_cidr_block" {
  description = "The source CIDR block to allow traffic from"
  type = "list"
}

variable "target_cidr_block" {
  description = "The target CIDR block to allow traffic to"
  type = "list"
}

resource "aws_security_group" "security_group" {
    name = "${var.sg_name}"
    description = "Security Group ${var.sg_name}"
    vpc_id = "${var.vpc_id}"

    // allow traffic for TCP 80
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = "${var.source_cidr_block}"
    }

    // allow traffic for TCP 443
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = "${var.source_cidr_block}"
    }

      egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = "${var.target_cidr_block}"
    }


    lifecycle {
      create_before_destroy = true
    }

}

output "sg_id" {
  value = "${aws_security_group.security_group.id}"
}
