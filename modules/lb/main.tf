resource "aws_lb" "main" {
  name               = var.service_name
  security_groups    = var.security_groups
  subnets            = var.subnets

  tags = {
    Environment = var.environment
  }
}
