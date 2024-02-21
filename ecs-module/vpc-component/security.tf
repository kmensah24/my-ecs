resource "aws_security_group" "alb_sg" {
name= "alb_sg"
description = "Security group for ALB"
vpc_id= aws_vpc.ecommerce_vpc.id


ingress {
from_port= 80
to_port= 80
protocol= "tcp"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
}


egress {
from_port= 0
to_port= 0
protocol= "-1"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
}

tags = {
Name = "alb-sg"
}
 }

