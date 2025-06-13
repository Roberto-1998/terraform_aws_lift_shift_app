resource "aws_launch_template" "vprofile-app-LT" {
  name = "vprofile-app-LT"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.vprofile_instance_profile.name
  }

  image_id = aws_ami_from_instance.vprofile-app-AMI.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t2.micro"
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.vprofile-app-SG.id] # ✅ Aquí, no fuera

  }
  key_name = aws_key_pair.vprofile-app-key.key_name


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "vprofile-app-LT"
      Project = var.PROJECT
    }
  }
}
