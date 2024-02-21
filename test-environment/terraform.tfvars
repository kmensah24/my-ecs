#vpc values
region= "eu-west-1"
project_name = "ecommerce"
vpc_cidr   = "10.0.0.0/16"
instance_tenancy = "default"

#subnet values
public_subnets_cidr  = ["10.0.8.0/24", "10.0.11.0/24"]
private_subnets_cidr = ["10.0.165.0/24", "10.0.145.0/24"]


#rds  values
allocated_storage = "25"
max_allocated_storage = "50"
engine = "mysql"
storage_type = "gp2"
engine_version = "5.7"
instance_class = "db.t2.micro"
username = "admin2"
password = "adminadmin2"
parameter_group_name = "default.mysql5.7"
db_name = "ecs-database"

#ecs values
repository_name = "mike-ecommerce"
image_tag = "latest"
memory = 512
cpu = 256