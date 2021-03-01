instance_type = "t2.micro"
// vpc_key = "poc"
subnet_tier = "med"
vpc_name = "vpc-dhhs-ncfast-curam-poc"
security_groups = ["ePassApp", "NCFastApp"]
name_prefix = "ePASSWebserver"
// alb_tg_name = "ncfast-websrvs-443"
server = "ncfast"
