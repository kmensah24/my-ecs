#ALB
resource "aws_alb" "ecs_alb" {
 name= "ecs-alb"
 internal= false
 load_balancer_type = "application"
 security_groups= [aws_security_group.alb_sg.id]

 enable_deletion_protection = false

 subnets = (aws_subnet.public_subnet.*.id)
 enable_http2= true
 idle_timeout= 60

 enable_cross_zone_load_balancing = true

 tags = {
 Name = "ecs-abl"
 }
 }


# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs_alb_tg.arn
    type             = "forward"
  }
}

# Target group
 resource "aws_alb_target_group" "ecs_alb_tg" {
 name= "ecs-alb-tg"
 port= 80
 protocol= "HTTP"
 vpc_id= aws_vpc.ecommerce_vpc.id
 target_type = "ip"

health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

 }

#ECS Service Autoscaling
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 6
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_alb_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

