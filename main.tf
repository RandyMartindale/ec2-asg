terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

/*
Get the VPC based on the vpc_name variable
*/
data "aws_vpc" "ncfast" {

  tags = {
    "Name" = var.vpc_name
  }
}

/*
get the subnet the VPC base on tier
spare, low, med, high
*/
data "aws_subnet_ids" "ncfast" {
  vpc_id = data.aws_vpc.ncfast.id

  tags = {
    "Tier" = var.subnet_tier
  }
}

/* 
 ami for image repository
*/
data "aws_ami" "ec2-ami" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "state"
    values = ["available"]
  }

  filter {
    name = "tag:Name"
    values = var.ami_name_filter
  }

}

/*
 get a list os security groups to assoicated with the ec2
 instance at launch
 */
data "aws_security_group" "ncfast" {
  count = length(var.security_groups)
  filter {
    name   = "tag:Name"
    values = [var.security_groups[count.index]]
  }
}

resource "aws_launch_template" "ePASS_Web_Server" {
  name_prefix   = "${var.name_prefix}-"
  image_id      = data.aws_ami.ec2-ami.id
  instance_type = var.instance_type
  # key_name = var.key_name
  # user_data     = data.template_file.cloud_init.rendered

  network_interfaces {
    description = "Primary network interface"
    associate_public_ip_address = false
    security_groups = data.aws_security_group.ncfast.*.id
  }

  # dynamic "iam_instance_profile" {
  #   for_each = var.iam_instance_profile != null ? [1] : []
  #   content {
  #     name = var.iam_instance_profile
  #   }
  # }


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.name_prefix
    }
  }
}



resource "aws_autoscaling_group" "ePASS_Web_Server" {
  desired_capacity = 1
  max_size = 2
  min_size = 1
  health_check_type = "ELB"
  vpc_zone_identifier = data.aws_subnet_ids.ncfast.ids


  target_group_arns = [ aws_alb_target_group.ncfast.arn ]

  launch_template {
    id = aws_launch_template.ePASS_Web_Server.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// data "aws_alb_target_group" "app_web_https"{
//   name = var.alb_tg_name
// }
// data "aws_alb" "epass" {
//   name = var.alb_name
// }

resource "aws_alb" "ncfast" {
   name = "dhhs-ncfast-poc-001-alb"
   security_groups = ["sg-02a18518d22463f35"]

   subnets = data.aws_subnet_ids.ncfast.ids 

 }

 resource "aws_alb_target_group" "ncfast" {
   name = "ncfast-curam-websrvs-443"  
   port = 443
   protocol = "HTTPS"
   vpc_id = data.aws_vpc.ncfast.id
   stickiness {
     type = "lb_cookie"
   }
   health_check {
     path = "/healthcheck.html"
     port         = 443
   }
 }

 resource "aws_alb_listener" "ncfast_https" {
   load_balancer_arn = aws_alb.ncfast.arn
   port = "443"
   protocol = "HTTPS"
   ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
   # certificate_arn = var.certificate_arn
   # depends_on = [  ]
   default_action {
     target_group_arn = aws_alb_target_group.ncfast.arn
     type = "forward"
   }
 }
 
 resource "aws_route53_zone" "web" {
   name = "awspoc.ncfast.dhhs.gov"
 }

 resource "aws_route53_record" "ncfast" {
   zone_id = aws_route53_zone.web.zone_id
   name = "zone"
   type = "A"
   alias {
    name = aws_alb.ncfast.dns_name
     zone_id = aws_alb.ncfast.zone_id
     evaluate_target_health = true
   }
 }
