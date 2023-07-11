##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {
  state = "available"
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #


module "app" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  cidr = var.aws_vpc_cidr_block

  azs            = slice(data.aws_availability_zones.available.names, 0, var.aws_vpc_public_subnet_count)
  public_subnets = [for subnet in range(var.aws_vpc_public_subnet_count) : cidrsubnet(var.aws_vpc_cidr_block, 8, subnet)]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  enable_dns_hostnames    = true
  map_public_ip_on_launch = var.aws_map_public_ip_on_launch

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-vpc" })
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "${local.naming_prefix}-nginx_sg"
  vpc_id = module.app.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = var.aws_ingress_port
    to_port     = var.aws_ingress_port
    protocol    = "tcp"
    cidr_blocks = [var.aws_vpc_cidr_block]
  }

  # outbound internet access
  egress {
    from_port   = var.aws_egress_port
    to_port     = var.aws_egress_port
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

resource "aws_security_group" "alb_sg" {
  name   = "${local.naming_prefix}-nginx_alb_sg"
  vpc_id = module.app.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = var.aws_ingress_port
    to_port     = var.aws_ingress_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = var.aws_egress_port
    to_port     = var.aws_egress_port
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}



