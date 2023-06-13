output "aws_security_group_rds_id" {
  value = aws_security_group.rds_sg.id
  description = "Id of RDS segurity group"
}

output "aws_pub_subnet_id_a" {
  value       = aws_subnet.public_subnet_a.id
  description = "The ID of public subnet"
}

output "aws_pri_subnet_id_a" {
  value       = aws_subnet.private_subnet_a.id
  description = "The ID of public subnet"
}

output "id_vpc" {
  value       = aws_vpc.main.id
  description = "The id of VPC"
}

output "private_subnets_id" {
  value = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}

output "all_subnets_id" {
  value = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id,
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

output "aws_all_subnets_id_public" {
  value = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}


output "aws_all_subnets_id_private" {
  value = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id,
  ]
}

output "aws_all_subnets_az" {
  value = [
    aws_subnet.private_subnet_a.availability_zone,
    aws_subnet.private_subnet_b.availability_zone,
  ]
}

output "web_instance_sg" {
  value = aws_security_group.web_instance_sg.id
}

output "all_sg"{
  value = [
    aws_security_group.web_instance_sg.id,
    aws_security_group.rds_sg.id
  ]
}