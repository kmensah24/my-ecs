resource "aws_vpc" "ecommerce_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = var.instance_tenancy
    enable_dns_hostnames = true
    enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"

  }
  
}

data "aws_availability_zones" "availability_zones" {
  
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = var.public_subnets_cidr [count.index]
  availability_zone       = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-${count.index+1}" 
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = var.private_subnets_cidr[count.index]
  availability_zone       = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-private-subnet-${count.index+1}" 
  }
}
  




#Internet gateway
resource "aws_internet_gateway" "pro-igw" {
  vpc_id = aws_vpc.ecommerce_vpc.id
  tags = {
    "Name"        = "${var.project_name}-igw"
    
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ecommerce_vpc.id
  tags = {
    Name        = "${var.project_name}-private-route-table"
    
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  tags = {
    Name        = "${var.project_name}-public-route-table"
    
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pro-igw.id
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "pro_eip" {
tags = {
 Name ="pro-eip"
}

}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.pro_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  tags = {
    Name        = "${var.project_name}-nat-gateway"
    
  }
}

# nat gateway routing
resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.private.id
  gateway_id             = aws_nat_gateway.nat.id
  destination_cidr_block = "0.0.0.0/0"

}