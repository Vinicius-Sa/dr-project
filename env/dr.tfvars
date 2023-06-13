project                   = "dissaster_recovery"
service_name              = "dr"
environment               = "symptest"
peer_vpc_id               = "vpc-"
aws_vpc_cidr_block        = "10.250.0.0/16"
aws_subnet_private_subnet_a = "10.250.100.0/24"
aws_subnet_private_subnet_b = "10.250.101.0/24"
aws_subnet_public_subnet_a = "10.250.200.0/24"
aws_subnet_public_subnet_b = "10.250.201.0/24"

#Ec2 variables
instance_type = "t2.micro"
volyme_type = "gp3"
volyme_syze = "20"
throughput = "200"
associate_public_ip_address = true #Associate public ip to instances
key_name = "vinicius-test"

#rds_aurora rds variables
cluster_name = "dr-cluster"
instance_class = "db.t3.medium"
instance_count = 1
password = "admin123"
preferred_maintenance_window = ""
rds_db_parameter_group_name = "sympdb-cluster-pgroup"
skip_final_snapshot = 1
