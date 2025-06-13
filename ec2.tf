resource "aws_instance" "vprofile-db01" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.vprofile-backend-key.key_name
  vpc_security_group_ids = [aws_security_group.vprofile-backend-SG.id]


  tags = {
    Name    = "vprofile-db01"
    Project = var.PROJECT
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("vprofile-backend-key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/mysql.sh"
  }


}


resource "aws_instance" "vprofile-mc01" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.vprofile-backend-key.key_name
  vpc_security_group_ids = [aws_security_group.vprofile-backend-SG.id]

  tags = {
    Name    = "vprofile-mc01"
    Project = var.PROJECT
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("vprofile-backend-key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/memcache.sh"
  }


}

resource "aws_instance" "vprofile-rmq01" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.vprofile-backend-key.key_name
  vpc_security_group_ids = [aws_security_group.vprofile-backend-SG.id]

  tags = {
    Name    = "vprofile-rmq01"
    Project = var.PROJECT
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("vprofile-backend-key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/rabbitmq.sh"
  }


}


resource "aws_instance" "vprofile-app01" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.vprofile-app-key.key_name
  vpc_security_group_ids = [aws_security_group.vprofile-app-SG.id]

  tags = {
    Name    = "vprofile-app01"
    Project = var.PROJECT
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("vprofile-app-key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/tomcat.sh"
  }
}

output "privateIps" {
  value = {
    vprofile-db01=aws_instance.vprofile-db01.private_ip
    vprofile-mc01=aws_instance.vprofile-mc01.private_ip
    vprofile-rmq01=aws_instance.vprofile-rmq01.private_ip
    vprofile-app01=aws_instance.vprofile-app01.private_ip
  }
}