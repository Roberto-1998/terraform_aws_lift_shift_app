resource "aws_security_group" "vprofile-lb-SG" {
  name        = "vprofile-lb-SG"
  description = "Allow HTTP from the Internet"

  tags = {
    Name    = "vprofile-lb-SG"
    Project = var.PROJECT
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.vprofile-lb-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6" {
  security_group_id = aws_security_group.vprofile-lb-SG.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_lb" {
  security_group_id = aws_security_group.vprofile-lb-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_lb" {
  security_group_id = aws_security_group.vprofile-lb-SG.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "vprofile-app-SG" {
  name        = "vprofile-app-SG"
  description = "Allow Traffic from the Load Balancer"

  tags = {
    Name    = "vprofile-app-SG"
    Project = var.PROJECT
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4_from_LB" {
  security_group_id            = aws_security_group.vprofile-app-SG.id
  referenced_security_group_id = aws_security_group.vprofile-lb-SG.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_myip_app" {
  security_group_id = aws_security_group.vprofile-app-SG.id
  cidr_ipv4         = "${var.MYIP}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}



resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_app" {
  security_group_id = aws_security_group.vprofile-app-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_app" {
  security_group_id = aws_security_group.vprofile-app-SG.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "vprofile-backend-SG" {
  name        = "vprofile-backend-SG"
  description = "Allow traffic from the main app and all backend instances"

  tags = {
    Name    = "vprofile-backend-SG"
    Project = var.PROJECT
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_open_ports_from_app" {
  security_group_id            = aws_security_group.vprofile-backend-SG.id
  referenced_security_group_id = aws_security_group.vprofile-app-SG.id
  ip_protocol                  = "tcp"
  for_each                     = toset(var.BACKEND_OPEN_PORTS)
  from_port                    = each.value
  to_port                      = each.value
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_myip_backend" {
  security_group_id = aws_security_group.vprofile-backend-SG.id
  cidr_ipv4         = "${var.MYIP}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_from_backend" {
  security_group_id            = aws_security_group.vprofile-backend-SG.id
  referenced_security_group_id = aws_security_group.vprofile-backend-SG.id
  from_port                    = 0
  ip_protocol                  = "tcp"
  to_port                      = 65535
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_backend" {
  security_group_id = aws_security_group.vprofile-backend-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_backend" {
  security_group_id = aws_security_group.vprofile-backend-SG.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}