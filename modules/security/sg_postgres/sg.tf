variable "sg_name" {}
variable "vpc_id" {}
variable "source_sg" {default = []}
variable "source_cidr" {default = []}

resource "aws_security_group" "security_group" {
    name = "${var.sg_name}"
    description = "Security Group ${var.sg_name}"
    vpc_id = "${var.vpc_id}"

    // allow traffic for TCP 5432
    ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        // these two are already a list, but I have to force it, bug?
        security_groups = ["${var.source_sg}"]
        cidr_blocks = ["${var.source_cidr}"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "sg_id" {
  value = "${aws_security_group.security_group.id}"
}
