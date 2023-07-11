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
resource "aws_vpc" "app" {
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "${local.naming_prefix}-vpc" })

}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id
  tags   = merge(local.common_tags, { Name = "${local.naming_prefix}-app" })
}

resource "aws_subnet" "public_subnets" {
  count                   = var.aws_vpc_public_subnet_count
  cidr_block              = cidrsubnet(var.aws_vpc_cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.aws_map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags                    = merge(local.common_tags, { Name = "${local.naming_prefix}-public-subnets-${count.index}" })
}

# ROUTING #
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-app" })
}

resource "aws_route_table_association" "app_subnets" {
  count          = var.aws_vpc_public_subnet_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.app.id
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "${local.naming_prefix}-nginx_sg"
  vpc_id = aws_vpc.app.id

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
  vpc_id = aws_vpc.app.id

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



