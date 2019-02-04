env = "dev"

region = "us-east-1"

#network
vpc_name = "dev"

vpc_cidr = "10.2.0.0/16"

public_cidr = "0.0.0.0/0"

vpc_azs = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c",
]

vpc_public_subnets = [
  "10.2.0.0/24",
  "10.2.1.0/24",
  "10.2.2.0/24",
]

vpc_private_subnets = [
  "10.2.3.0/24",
  "10.2.4.0/24",
  "10.2.5.0/24",
]

vpc_private_subnets_extended = [
  "10.2.6.0/24",
  "10.2.7.0/24",
  "10.2.8.0/24",
]


