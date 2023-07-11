##################################################################################
# CONFIGURATION - added for Terraform 0.14
##################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.6.2"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~>2.0"
    }
  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  profile = "deep-dive"
  region  = var.region
}

provider "consul" {
  address    = "${var.consul_address}:${var.consul_port}"
  datacenter = var.consul_datacenter
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

data "consul_keys" "networking" {
  key {
    name = "networking"
    path = "networking/configuration/globo-primary/net_info"
  }

  key {
    name = "common_tags"
    path = "networking/configuration/globo-primary/common_tags"
  }
}

##################################################################################
# LOCALS
##################################################################################

locals {
  cidr_block   = jsondecode(data.consul_keys.networking.var.networking)["cidr_block"]
  subnet_count = jsondecode(data.consul_keys.networking.var.networking)["subnet_count"]
  common_tags  = jsondecode(data.consul_keys.networking.var.common_tags)
  public_cidrsubnets = [
    for index in range(local.subnet_count) : templatefile("${path.module}/cidrsubnet.tpl", {
      vpc_cidr = local.cidr_block
      offset = index 
    })
  ]
  private_cidrsubnets = [
    for index in range(local.subnet_count) : templatefile("${path.module}/cidrsubnet.tpl", {
      vpc_cidr = local.cidr_block
      offset = index + 10
    })
  ]
}

# $${cidrsubnet(vpc_cidr,8,current_count)}
##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.0"

  name = "globo-primary"

  cidr            = local.cidr_block
  azs             = slice(data.aws_availability_zones.available.names, 0, local.subnet_count)
  private_subnets = local.private_cidrsubnets
  public_subnets  = local.public_cidrsubnets

  enable_nat_gateway = false

  create_database_subnet_group = false


  tags = local.common_tags
}





