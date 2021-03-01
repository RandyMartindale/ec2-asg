NCFast PoC EC2 module with ASG
===========

Deploy EC2 modules base subnet tier.  ALB, launch template adn ASG are created


Module Input Variables
----------------------

- `instance_type` - instance to use for deployment. Default is t2.micro
- `vpc_name` - name used to filter "Name" for data aws_vpc
- `subnet_tier` - name used to filter "Tier". Current values are 'low', 'spare', 'med' and 'high'
- `ami_filter` - tag name to determine AMI to be used.  

Usage
-----

```hcl
module "ec2" {

  source = "git::ssh://git@github.com/RandyMartindale/ec2-asg.git"

  instance_type   = var.instance_type
  vpc_name        = var.vpc_name
  subnet_tier     = var.subnet_tier
  ami_name_filter = var.ami_name_filter

}
```

Outputs
=======

- `TBD` 

Authors
=======

randolph.martindale@dhhs.nc.gov

