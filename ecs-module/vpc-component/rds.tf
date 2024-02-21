resource "aws_db_instance" "my_database" {
identifier= "my-db-instance"
allocated_storage= var.allocated_storage
max_allocated_storage = var.max_allocated_storage
storage_type= var.storage_type
engine= var.engine
engine_version= var.engine_version
instance_class= var.instance_class
username= var.username
password= var.password
parameter_group_name= var.parameter_group_name
publicly_accessible= true
multi_az= false
backup_retention_period = 7
skip_final_snapshot= true

tags = {
Name = "MyDatabase"
}
}