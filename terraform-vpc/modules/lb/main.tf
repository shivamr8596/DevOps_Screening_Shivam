resource "aws_lb" "LB" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.type

  security_groups = [
    var.security_group_id
  ]

  subnets = var.subnet_ids

  access_logs {
    bucket  = var.access_logs_bucket_id
    prefix  = var.lb_logs_prefix
    enabled = var.enable_access_logs
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}


resource "aws_lb_target_group" "target_group" {
  for_each = {
    for tg in var.target_groups :
    tg.name => tg
  }

  name        = each.value.name
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = each.value.target_type

  dynamic "health_check" {
    for_each = each.value.health_check != null ? [each.value.health_check] : []

    content {
      enabled             = lookup(health_check.value, "enabled", true)
      path                = lookup(health_check.value, "path", null)
      protocol            = lookup(health_check.value, "protocol", null)
      port                = lookup(health_check.value, "port", null)
      interval            = lookup(health_check.value, "interval", null)
      timeout             = lookup(health_check.value, "timeout", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
    }
  }

  tags = merge(var.tags, {
    Name = each.value.name
  })
}


resource "aws_lb_target_group_attachment" "attachment" {
  for_each = var.attachments

  target_group_arn = aws_lb_target_group.target_group[
    each.value.target_group_name
  ].arn

  target_id = each.value.target_id
  port      = each.value.port
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.LB.arn

  port     = var.lb_listener_port
  protocol = var.lb_listener_protocol

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.target_group[
      var.default_target_group_name
    ].arn
  }
}


resource "aws_lb_listener_rule" "listener_rule" {
  for_each = {
    for index, rule in var.listener_rules :
    index => rule
  }

  listener_arn = aws_lb_listener.listener.arn
  priority     = each.value.priority

  action {
    type = "forward"

    target_group_arn = aws_lb_target_group.target_group[
      each.value.target_group_name
    ].arn
  }

  dynamic "condition" {
    for_each = each.value.path_patterns != null ? [each.value.path_patterns] : []

    content {
      path_pattern {
        values = condition.value
      }
    }
  }

  dynamic "condition" {
    for_each = each.value.host_headers != null ? [each.value.host_headers] : []

    content {
      host_header {
        values = condition.value
      }
    }
  }
}

