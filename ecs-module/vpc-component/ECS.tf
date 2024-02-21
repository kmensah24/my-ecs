# ECS CLUSTER
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecommerce_cluster"
}

resource "aws_ecs_cluster_capacity_providers" "ecommerce" {
  cluster_name = aws_ecs_cluster.ecs_cluster.id

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

data "aws_ecr_image" "latest" {
  repository_name = "mike-ecommerce"
  image_tag       = "latest"
}


#Ecs execution role
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        },
      },
    ],
  })
}

# Task Definition
 resource "aws_ecs_task_definition" "ecs_task" {
  family = "ecs"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.cpu
  memory = var.memory

execution_role_arn = aws_iam_role.ecs_execution_role.arn


  container_definitions = jsonencode([
    {
      name      = "${data.aws_ecr_image.latest.image_tag}"
      image     = "latest"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
   
  ])

}

# Ecs service
resource "aws_ecs_service" "ecs_alb_service" {
 name= "ecs-alb-service"
 cluster= aws_ecs_cluster.ecs_cluster.id
 task_definition = aws_ecs_task_definition.ecs_task.arn
 launch_type= "FARGATE"
 desired_count= 1

network_configuration {
 subnets        = (aws_subnet.public_subnet.*.id)
 security_groups = [aws_security_group.alb_sg.id]
  assign_public_ip = true 
 }

load_balancer {
    target_group_arn = aws_alb_target_group.ecs_alb_tg.arn
    container_name   = "${data.aws_ecr_image.latest.image_tag}"
    container_port   = 80
  }

 depends_on = [aws_alb_listener.front_end]

}
