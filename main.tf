locals {
  project-name = "prueba-web"
  # vpc_id       = "vpc-419f2938"
  # subnet_id    = "subnet-36bd5e4f"

  vpc_cidr           = "10.0.0.0/16"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
}


resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_security_group" "ingress-ofi-ssh" {
  name   = "${local.project-name}-sg"
  vpc_id = module.vpc.vpc_id


  ingress {
    cidr_blocks = [
      "***/32" # Red casa
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "runner-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  # subnet_id                   = local.subnet_id
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.ingress-ofi-ssh.id}"]

  tags = {
    Name = "${local.project-name}-instance"
  }
}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 5.0"
  name            = "${local.project-name}-vpc"
  cidr            = local.vpc_cidr
  azs             = local.availability_zones
  private_subnets = [for k, v in local.availability_zones : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.availability_zones : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true
}
