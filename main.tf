provider "aws" {
  region = "us-east-1"
}

terraform {

  required_version = "~> 1.2.6"

  required_providers {
    aws  = "~> 3.74.3"
  }

  backend "s3" {
    bucket = "symplicity-terraform-state"
    key    = "symplicity-terraform-state/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "symplicity-terraform-state"{
  bucket = "symplicity-terraform-state"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }
}

locals {
  resource  = "${var.project}-${var.service_name}-${var.environment}"
  log_prefix  = "logs/${var.environment}"
  environment = var.environment


  multiple_instances = {
    web = {
      instance_type     = var.instance_type
      availability_zone = element(module.network.aws_all_subnets_az, 0)
      subnet_id         = element(module.network.aws_all_subnets_id_private, 0)
      root_block_device = [
        {
          encrypted   = true
          volume_type = var.volume_type
          throughput  = var.throughput
          volume_size = var.volume_size
          tags = {
            Name = "my-root-block"
          }
        }
      ]
    }
    bastion = {
      instance_type     = var.instance_type
      availability_zone = element(module.network.aws_all_subnets_az, 1)
      subnet_id         = element(module.network.aws_all_subnets_id_private, 1)
      root_block_device = [
        {
          encrypted   = true
          volume_type = var.volume_type
          volume_size = var.volume_size
        }
      ]
    }
  }
  tags = {
    Name        = local.resource
    project     = var.project
    service     = var.service_name
    environment = var.environment
  }
}

module "ec2_multiple" {
  source = "./modules/ec2"

  for_each = local.multiple_instances

  user_data_base64            = base64encode(local.metadata)
  user_data_replace_on_change = true

  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = module.network.all_sg
  associate_public_ip_address = var.associate_public_ip_address
  key_name = var.key_name

  tags = local.tags
}

module "network" {
  source = "./modules/network"
  region = var.region
  default_tags = local.tags

  aws_vpc_cidr_block          = var.aws_vpc_cidr_block
  aws_subnet_private_subnet_a = var.aws_subnet_private_subnet_a
  aws_subnet_private_subnet_b = var.aws_subnet_private_subnet_b
  aws_subnet_public_subnet_a  = var.aws_subnet_public_subnet_a
  aws_subnet_public_subnet_b  = var.aws_subnet_public_subnet_b

  peer_vpc_id         = var.peer_vpc_id
  environment         = var.environment
  aws_service_security_group_ids = [module.network.web_instance_sg]
}

module "vpc" {
  source = "./modules/terraform-aws-modules/terraform-aws-vpc"
  name   = "${var.project}-${var.environment}"
  cidr   = "${lookup(var.cidr_block, var.environment)}.0.0/16"
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  azs = [
        "${lookup(var.region, var.environment)}a",
        "${lookup(var.region, var.environment)}b",
    ]
}

/*module "efs_file_system" {
  source = "./modules/efs"
  subnet_id_a = var.aws_subnet_public_subnet_a
  subnet_id_b = var.aws_subnet_public_subnet_b
}*/

module "rds_aurora" {
  source = "./modules/rds_aurora"
  aws_db_subnet_group_id = module.network.aws_security_group_rds_id
  cluster_name = var.cluster_name
  instance_class = var.instance_class
  instance_count = var.instance_count
  password = var.password
  preferred_maintenance_window = var.preferred_maintenance_window
  rds_db_parameter_group_name = var.rds_db_parameter_group_name
  skip_final_snapshot = var.skip_final_snapshot

  tags = local.tags
}

