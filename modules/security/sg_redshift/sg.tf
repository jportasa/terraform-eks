variable "sg_name" {}
variable "vpc_id" {}
variable "source_cidr_block" {default = []}

resource "aws_security_group" "security_group" {
    name = "${var.sg_name}"
    description = "Security Group ${var.sg_name}"
    vpc_id = "${var.vpc_id}"

    // allows traffic from the SG itself for tcp
    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "tcp"
        self      = true
    }

    // allow traffic for TCP 3306
    ingress {
        from_port   = 5439
        to_port     = 5439
        protocol    = "tcp"
        cidr_blocks = "${var.source_cidr_block}"
    }

}

output "id" {value = "${aws_security_group.security_group.id}"}
