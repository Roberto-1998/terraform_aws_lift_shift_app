resource "aws_ami_from_instance" "vprofile-app-AMI" {
  name               = "vprofile-app-AMI"
  source_instance_id = aws_instance.vprofile-app01.id

  tags = {
    Name    = "vprofile-app-AMI"
    Project = var.PROJECT
  }
}