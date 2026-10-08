resource "aws_vpc" "main" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "vpc"
  })
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.vpc_availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "Public Subnet ${count.index + 1}"
  })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.vpc_availability_zones[count.index]

  tags = merge(var.tags, {
    Name = "Private Subnet ${count.index + 1}"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "internet-gateway"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "Public Route Table"
  })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "Public NACL"
  })
}

resource "aws_network_acl_rule" "public_inbound_web" {
  for_each = {
    for index, port in var.alb_ingress_ports :
    tostring(port) => index
  }

  network_acl_id = aws_network_acl.public.id
  rule_number    = 100 + each.value
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.destination_cidr_block
  from_port      = tonumber(each.key)
  to_port        = tonumber(each.key)
}

resource "aws_network_acl_rule" "public_inbound_app_response" {
  for_each = {
    for index, cidr in var.private_subnet_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.public.id
  rule_number    = 200 + each.value
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_outbound_ephemeral" {
  for_each = {
    for index, cidr in var.alb_ingress_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.public.id
  rule_number    = 200 + each.value
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_outbound_app" {
  for_each = {
    for index, cidr in var.private_subnet_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.public.id
  rule_number    = 300 + each.value
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = var.application_port
  to_port        = var.application_port
}


resource "aws_network_acl_association" "public" {
  count = length(var.public_subnet_cidrs)

  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "Private NACL"
  })
}

resource "aws_network_acl_rule" "private_inbound_app" {
  for_each = {
    for index, cidr in var.public_subnet_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.private.id
  rule_number    = 100 + each.value
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = var.application_port
  to_port        = var.application_port
}


resource "aws_network_acl_rule" "public_outbound_listener" {
  for_each = {
    for index, port in var.alb_ingress_ports :
    tostring(port) => index
  }

  network_acl_id = aws_network_acl.public.id
  rule_number    = 400 + each.value

  egress      = true
  protocol    = "tcp"
  rule_action = "allow"

  cidr_block = var.destination_cidr_block
  from_port  = tonumber(each.key)
  to_port    = tonumber(each.key)
}

resource "aws_network_acl_rule" "private_inbound_postgres" {
  for_each = {
    for index, cidr in var.private_subnet_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.private.id
  rule_number    = 200 + each.value
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = var.database_port
  to_port        = var.database_port
}

resource "aws_network_acl_rule" "private_inbound_ephemeral" {
  for_each = {
    for index, cidr in var.public_subnet_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.private.id
  rule_number    = 300 + each.value
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_inbound_db_response" {
  for_each = {
    for index, cidr in var.private_subnet_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.private.id
  rule_number    = 400 + each.value
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_outbound_ephemeral" {
  for_each = {
    for index, cidr in var.public_subnet_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.private.id
  rule_number    = 100 + each.value
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_outbound_postgres" {
  for_each = {
    for index, cidr in var.private_subnet_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.private.id
  rule_number    = 200 + each.value
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = var.database_port
  to_port        = var.database_port
}

resource "aws_network_acl_rule" "private_outbound_db_response" {
  for_each = {
    for index, cidr in var.private_subnet_cidrs :
    cidr => index
  }

  network_acl_id = aws_network_acl.private.id
  rule_number    = 300 + each.value
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.key
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_association" "private" {
  count = length(var.private_subnet_cidrs)

  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private[count.index].id
}
