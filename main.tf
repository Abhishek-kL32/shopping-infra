############################################
# KeyPair Creation                         #
############################################


resource "aws_key_pair" "shopping_auth" {

  key_name   = "${var.project_name}-${var.project_env}"
  public_key = file("shopping.pub")
  tags = {
    "Name" = "${var.project_name}-${var.project_env}"
  }
}

############################################
# zomato Security group                    #
############################################


resource "aws_security_group" "shopping_security_group" {
  name        = "${var.project_name}-${var.project_env}-frontend"
  description = "${var.project_name}-${var.project_env}-frontend"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.project_env}-frontend"
  }
}


############################################
# creating Ec2 Instance                    #
############################################

resource "aws_instance" "frontend" {

  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.shopping_auth.key_name
  vpc_security_group_ids = [resource.aws_security_group.shopping_security_group.id]
  tags = {
    "Name" = "${var.project_name}-${var.project_env}-frontend"
  }

  lifecycle {
    create_before_destroy = true
  }
}


############################################
# create record for webserver              #
############################################

resource "aws_route53_record" "webserver" {

  zone_id = data.aws_route53_zone.zone-details.id
  name    = "${var.hostname}.${var.hosted_zone_name}"
  type    = "A"
  ttl     = 300
  records = [resource.aws_instance.frontend.public_ip]
}

