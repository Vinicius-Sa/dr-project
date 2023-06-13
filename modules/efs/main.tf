resource "aws_efs_file_system" "efs" {
  creation_token = "dr-efs"

  tags = {
    Name = "dr-efs"
  }
}
resource "aws_efs_mount_target" "efs-mount-a" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.subnet_id_a
}
/*resource "aws_efs_mount_target" "efs-mount-b" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.subnet_id_b
}*/
