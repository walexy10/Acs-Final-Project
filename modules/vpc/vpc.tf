
# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Vpc" },
    var.tags,
  )
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Vpc-Igw" },
    var.tags,
  )
}

# Create Public IP for NAT Gateway
resource "aws_eip" "natgtwip" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc   = true

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Vpc-Natgtwip" },
    var.tags,
  )
}


# Create public route table for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.anywhere
    gateway_id = join("", aws_internet_gateway.igw.*.id)
  }

  tags = {
    "Name" = "${var.environment_prefix}-${var.group}-Public-Rt"
  }
}

# Create private route table for private subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.anywhere
    gateway_id = join("", aws_nat_gateway.natgtw.*.id)
  }

  tags = {
    "Name" = "${var.environment_prefix}-${var.group}-Private-Rt"
  }
}


# Create private subnets
resource "aws_subnet" "web_subnet_private" {
  count             = length(var.web_subnet_cidr_private)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.web_subnet_cidr_private[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Web-Subnet-${count.index}" },
    var.tags,
  )
}

# Create public subnets
resource "aws_subnet" "lb_subnet_public" {
  count             = length(var.lb_subnet_cidr_public)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.lb_subnet_cidr_public[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Lb-Subnet-${count.index}" },
    var.tags,
  )
}


# Create NAT Gateway
resource "aws_nat_gateway" "natgtw" {
  count = var.enable_nat_gateway ? 1 : 0
  #subnet_id         = element(concat(aws_subnet.web_subnet_private.*.id, aws_subnet.web_subnet_private.*.id, aws_subnet.db_subnet_private.*.id), count.index)
  subnet_id         = element(aws_subnet.lb_subnet_public.*.id, count.index)
  connectivity_type = "public"
  allocation_id     = aws_eip.natgtwip[count.index].id

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Vpc-Natgtw" },
    var.tags,
  )
}

# Create private route table association with private subnets
resource "aws_route_table_association" "web_private_rt_assoc" {
  count          = length(var.web_subnet_cidr_private)
  subnet_id      = aws_subnet.web_subnet_private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "lb_public_rt_association" {
  count          = length(var.lb_subnet_cidr_public)
  subnet_id      = aws_subnet.lb_subnet_public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


# Security Groups

resource "aws_security_group" "aws-web-sg" {
  #name        = "${lower(var.app_name)}-${var.app_environment}-windows-sg"
  description = "Allow incoming connections"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = var.alb_listener_port
    to_port     = var.alb_listener_port
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
    description = "Allow incoming HTTP connections"
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
    description = "Allow incoming SSH connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere]
  }

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Web-Sg" },
    var.tags,
  )

}

resource "aws_security_group" "aws-lb-sg" {
  description = "Allow incoming connections"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
    description = "Allow incoming HTTP connections"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
    description = "Allow incoming SSH connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere]
  }

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Lb-Sg" },
    var.tags,
  )
}