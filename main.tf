module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_1_subnet_cidr = var.public_1_subnet_cidr
  public_2_subnet_cidr = var.public_2_subnet_cidr
  private_1_subnet_cidr = var.private_1_subnet_cidr
  private_2_subnet_cidr = var.private_2_subnet_cidr
  az_1 = var.az_1
  az_2 = var.az_2
}

module "rds" {
  source = "./modules/rds"
  private_subnet_1 = module.vpc.private_subnet_1
  private_subnet_2 = module.vpc.private_subnet_2
  db_username = var.db_username
  db_password = var.db_password
  rds_sg_id = module.sg.rds_sg_id
  db_name = var.db_name
}

module "ec2_1" {
  source = "./modules/ec2"
  subnet_id = module.vpc.public_subnet_1
  instance_type = var.instance_type
  ami = var.ami
  key_name = var.key_name
  sg_id = module.sg.ec2_sg_id

  db_name      = module.rds.db_name
  db_username  = module.rds.db_username
  db_password  = module.rds.db_password
  rds_endpoint = module.rds.rds_endpoint
  rds_port     = module.rds.rds_port
}

module "ec2_2" {
  source = "./modules/ec2"
  subnet_id = module.vpc.public_subnet_2
  instance_type = var.instance_type
  ami = var.ami
  key_name = var.key_name
  sg_id = module.sg.ec2_sg_id

  db_name      = module.rds.db_name
  db_username  = module.rds.db_username
  db_password  = module.rds.db_password
  rds_endpoint = module.rds.rds_endpoint
  rds_port     = module.rds.rds_port
}

module "sg" {
    source = "./modules/sg"
    vpc_id = module.vpc.vpc_id
    my_ip = var.my_ip
    # ec2_sg_id = module.sg.ec2_sg_id   # << pass EC2 SG
}

module "alb" {
  source = "./modules/alb"
  alb_sg_id = module.sg.alb_sg_id
  subnets = [
    module.vpc.public_subnet_1,
    module.vpc.public_subnet_2
  ]
  vpc_id = module.vpc.vpc_id
  ec2_1_id = module.ec2_1.instance_id
  ec2_2_id = module.ec2_2.instance_id
  certificate_arn = module.acm.certificate_arn
}

module "acm" {
  source = "./modules/acm"
  domain_name = var.domain_name
  zone_name = var.zone_name
  # zone_id          = module.route53.hosted_zone
}

module "route53" {
  source       = "./modules/route53"
  zone_name    = var.zone_name
  record_name  = var.record_name        # this will create wordpress.hastiamin.co.uk
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}