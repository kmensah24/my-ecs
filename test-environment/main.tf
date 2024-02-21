module "vpc" {
  source = "../ecs-module/vpc-component"

#vpc attributes
  project_name     = var.project_name
  region           = var.region
  vpc_cidr         = var.vpc_cidr
  instance_tenancy = var.instance_tenancy

  #subnet attributes
  public_subnets_cidr = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  


  #rds attributes
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage
  engine                = var.engine
  storage_type          = var.storage_type
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  username              = var.username
  password              = var.password
  parameter_group_name  = var.parameter_group_name
  db_name               = var.db_name

  #Ecs attributes
  repository_name = var.repository_name
  cpu             = var.cpu
  image_tag       = var.image_tag
  memory          = var.memory





}