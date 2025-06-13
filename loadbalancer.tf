resource "aws_lb" "vprofile-ALB" {
  name               = "vprofile-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.vprofile-lb-SG.id]
  subnets            = data.aws_subnets.default.ids


  enable_deletion_protection = false



  tags = {
    Name    = "vprofile-ALB"
    Project = var.PROJECT
  }
}


resource "aws_lb_target_group" "vprofile-las-TG" {
  name        = "vprofile-las-TG"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.default.id
  stickiness {
    type = "lb_cookie"
  }
  tags = {
    Name    = "vprofile-las-TG"
    Project = var.PROJECT
  }
}

/* resource "aws_lb_target_group_attachment" "vprofile-instance" {
  target_group_arn = aws_lb_target_group.vprofile-las-TG.arn
  target_id        = aws_instance.vprofile-app01.id
  port             = 8080
}
 */

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.vprofile-ALB.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vprofile-las-TG.arn
  }
}

output "app_link" {
  value = "http://${aws_lb.vprofile-ALB.dns_name}"
}