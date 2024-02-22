#vpc values
region           = "eu-west-1"
project_name     = "Ecs-ecommerce"
vpc_cidr         = "10.0.0.0/16"
instance_tenancy = "default"

#subnet values
public_subnets_cidr  = ["10.0.0.0/22", "10.0.12.0/22"]
private_subnets_cidr = ["10.0.16.0/22", "10.0.32.0/22"]

#rds  values
allocated_storage     = 20
max_allocated_storage = 100
engine                = "mysql"
storage_type          = "gp2"
engine_version        = "5.7"
instance_class        = "db.t2.micro"
username              = "admin"
password              = "adminadmin"
parameter_group_name  = "default.mysql5.7"
db_name               = "ecs-database"

#ecs values
repository_name = "mike-ecommerce"
image_tag       = "latest"
memory          = 512
cpu             = 256


