locals {
  project-name = "prueba-web"
  # home_ip      = provider::dotenv::get_by_key("HOME_IP", ".env")

  vpc_cidr           = "10.0.0.0/16"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
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

resource "aws_security_group" "ingress_ofi_ssh" {
  name   = "${local.project-name}-sg"
  vpc_id = module.vpc.vpc_id


  // SSH ingress rule
  ingress {
    cidr_blocks = [
      # "${local.home_ip}/32",
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  // HTTP ingress rule
  ingress {
    cidr_blocks = [
      # "${local.home_ip}/32",
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  // HTTPS ingress rule
  ingress {
    cidr_blocks = [
      # "${local.home_ip}/32"
    ]
    from_port = 443
    to_port   = 443
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


resource "tls_private_key" "instance_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.instance_key.public_key_openssh
}

resource "aws_instance" "runner_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  # subnet_id                   = local.subnet_id
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.ingress_ofi_ssh.id}"]

  tags = {
    Name = "${local.project-name}-instance"
  }
}

# Add the Hosted Zone for the domain
resource "aws_route53_zone" "markelca_com" {
  name = "markelca.com"
}

# Create an A record to point to your instance's public IP
resource "aws_route53_record" "markelca_com_record" {
  zone_id = aws_route53_zone.markelca_com.zone_id
  name    = "markelca.com" # Replace with "www.markelca.com" if using a subdomain
  type    = "A"
  ttl     = 300
  records = [aws_instance.runner_instance.public_ip]
}

# Optional: If you're using a CNAME for a subdomain like "www"
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.markelca_com.zone_id
  name    = "www.markelca.com"
  type    = "CNAME"
  ttl     = 300
  records = ["markelca.com"]
}


