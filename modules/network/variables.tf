variable "default_tags" {
  type        = map
  default     = {}
  description = "Tags definition."
}

variable "region" {
  type = string
  description = "AWS region."
  default = "us-east-1"
}

#Conexao VPC Peering
variable "peer_vpc_id" {
  default = ""
}

variable subnet_infra_legacy {
  type = string
  default = ""
}


variable "aws_vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.250.0.0/16"
}

variable "aws_subnet_private_subnet_a" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.250.100.0/24"
}

variable "aws_subnet_private_subnet_b" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.250.101.0/24"
}

variable "aws_subnet_public_subnet_a" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.250.200.0/24"
}

variable "aws_subnet_public_subnet_b" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.250.201.0/24"
}

/*variable "environment" {
  type = string
  description = "Application environment."
}*/

variable "aws_service_security_group_ids" {
  type        = list(any)
  description = "The IDs from service security group to ingress on RDS/documentdb cluster."
}

###################### dynamic subnets #################################
variable "cidr_block"{
  type = map
  default = {
    dissaster-recovery  = "10.250"
    dev                 = "10.200"
  }
}

locals {
  private_subnets = [
        "${lookup(var.cidr_block, var.environment)}.100.0/24",
        "${lookup(var.cidr_block, var.environment)}.101.0/24"
    ]
  public_subnets          = [
        "${lookup(var.cidr_block, var.environment)}.200.0/24",
        "${lookup(var.cidr_block, var.environment)}.201.0/24",
    ]
}

variable "environment" {
  type = string
  description = "Deployment environment, Options: dissaster-reccovery, dev"
}