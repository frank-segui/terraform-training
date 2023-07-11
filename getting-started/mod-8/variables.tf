variable "aws_region" {
  type        = string
  description = "Region to use for AWS resources"
  default     = "us-east-1"
}

variable "aws_vpc_cidr_block" {
  type        = string
  description = "CIDR block for AWS VPC"
  default     = "10.0.0.0/16"
}

variable "aws_vpc_public_subnet_count" {
  type        = number
  description = "Number of public subnets to create"
  default     = 2
}

variable "aws_map_public_ip_on_launch" {
  type        = bool
  description = "Map public ip on launch"
  default     = true
}

variable "aws_ingress_port" {
  type        = number
  description = "Port for ingress"
  default     = 80
}

variable "aws_egress_port" {
  type        = number
  description = "Port for egress"
  default     = 0
}

variable "aws_instance_size" {
  type        = map(string)
  description = "Map for instance sizes"
  default = {
    small  = "t2.micro"
    medium = "t2.medium"
    large  = "t2.large"
  }
}

variable "aws_instance_count" {
  type        = number
  description = "Number of instances to create"
  default     = 2
}

variable "company" {
  type        = string
  description = "Company name"
  default     = "Globomantics"
}

variable "project" {
  type        = string
  description = "Project"
}

variable "billing_code" {
  type        = string
  description = "Billing Code"
}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources"
  default     = "globo-web-app"
}

variable "environment" {
  type        = string
  description = "Environment for all resources"
  default     = "dev"
}