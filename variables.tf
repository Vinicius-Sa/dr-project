##################################             ###############################
#                                      ENV                                   #
##################################             ###############################
variable "environment" {
  type = string
  description = "Deployment environment, Options: dissaster-reccovery, dev"
}

variable "project" {
  type = string
  description = "Desired name for product resources identification."
}

variable "service_name" {
  type = string
  description = "Service name description."
}

##################################             ###############################
#                                  DYNAMIC VPC                               #
##################################             ###############################
variable "cidr_block"{
  type = map
  default = {
    symptest            = "10.250"
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

variable "region" {
  type =map(string)
  description = "map region per environment"
  default = {
    "symptest"           = "us-east-1"
    "dev"                = "us-east-2"
  }
}

##################################             ###############################
#                                     EC2                                    #
##################################             ###############################
variable "associate_public_ip_address" {
  type = string
  description = " Associate an public ipv4 ip to instance"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "throughput" {
  type         = string
  description  = " Instance volume throughput"
  default      = "gp3"
}

variable "volume_size" {
  type         = string
  description  = " Instance volume size"
  default      = "gp3"
}

variable "instance_type" {
  type        = string
  description = "Instance Type, default t2 micro"
  default     = "t2.micro"
}

##################################             ###############################
#                                  RDS AURORA                                #
##################################             ###############################
variable "cluster_name" {
  type = string
}

variable "instance_class" {
  type        = string
  description = "Instance class for database" #https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html
}

variable "instance_count" {
  type        = string
  description = "Instance count for rds cluster"
}

variable "password" {
  type        = string
  description = "Password for rds database root user."
}

variable "preferred_maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: \"ddd:hh24:mi-ddd:hh24:mi\". Eg: \"Mon:00:00-Mon:03:00\". UTC"
}

variable "rds_db_parameter_group_name" {
  type        = string
  description = "The name of the CLUSTER parameter group "
}

variable "skip_final_snapshot" {
  type        = string
  description = "Allow auto destuction of database"
}

variable "volume_type" {
  type         = string
  description  = " Instance volume type"
  default      = "gp3"
}

