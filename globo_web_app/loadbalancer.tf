##################################################################################
# DATA
##################################################################################

# AWS Elactic Load Balancer Service Account For Load Balancer access
data "aws_elb_service_account" "root" {}

##################################################################################
# RESOURCES
##################################################################################

# AWS Application Load Balancer
resource "aws_lb" "nginx" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.web_bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags
}

# Target Group for Load Balancer
resource "aws_lb_target_group" "nginx" {
  name     = "${local.name_prefix}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

# Listener Configuration for target group
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  tags = local.common_tags
}

# Attachment to EC2 instances
resource "aws_lb_target_group_attachment" "nginx" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}
