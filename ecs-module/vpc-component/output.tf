output "region"{
    value = var.region 
}

output "project_name"{
    value = var.project_name
}

output "vpc_id"{
    value = aws_vpc.ecommerce_vpc.id
}

output "public_subnets_id"{
    value = aws_subnet.public_subnet.*.id
}


output "private_subnet_id"{
    value = aws_subnet.private_subnet.*.id
}


output "alb_hostname" {
  value = aws_alb.ecs_alb.dns_name
}