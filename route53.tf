resource "aws_route53_zone" "private" {
  name = "vprofile.in"
  
  
  vpc {
    vpc_id = data.aws_vpc.default.id
  }

  tags = {
    Project=var.PROJECT
  }
}

resource "aws_route53_record" "db01_record" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db01"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.vprofile-db01.private_ip]
}

resource "aws_route53_record" "mc01_record" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "mc01"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.vprofile-mc01.private_ip]
}

resource "aws_route53_record" "rmq01_record" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "rmq01"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.vprofile-rmq01.private_ip]
}

resource "aws_route53_record" "app01_record" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "app01"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.vprofile-app01.private_ip]
}

output "privateRoutes" {
  value = {
    vprofile-db01=aws_route53_record.db01_record.fqdn
    vprofile-mc01=aws_route53_record.mc01_record.fqdn
    vprofile-rmq01=aws_route53_record.rmq01_record.fqdn
    vprofile-app01=aws_route53_record.app01_record.fqdn
  }
}