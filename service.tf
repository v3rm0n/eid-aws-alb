resource "aws_ecs_cluster" "demo" {
  name = "demo"
}

resource "aws_ecs_task_definition" "demo" {
  family                   = "demo"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = jsonencode([
    {
      name         = "demo"
      image        = "mendhak/http-https-echo:31"
      essential    = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])

  network_mode = "awsvpc"

  memory = "512"
  cpu    = "256"
}

resource "aws_security_group" "demo_service" {
  name        = "demo-service"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.demo_lb.id]
  }
}

resource "aws_ecs_service" "demo" {
  name            = "demo"
  cluster         = aws_ecs_cluster.demo.id
  task_definition = aws_ecs_task_definition.demo.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.demo.arn
    container_name   = "demo"
    container_port   = 8080
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 1
    weight            = 1
  }

  network_configuration {
    subnets          = data.aws_subnets.all.ids
    # Just because we are using a default VPC which doesn't have private subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.demo_service.id]
  }
}