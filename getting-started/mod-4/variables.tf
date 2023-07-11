variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "Region to use for AWS resources"
  default     = "us-east-1"
}

variable "billing_tag" {}

variable "aws_vpc_cidr_block" {
  type        = string
  description = "CIDR block for AWS VPC"
  default     = "10.0.0.0/16"
}

variable "aws_subnet_cidr_block" {
  type        = string
  description = "CIDR block for AWS VPC"
  default     = "10.0.0.0/24"
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