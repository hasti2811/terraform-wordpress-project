# VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
}

# gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public-1.id

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public-2.id

  depends_on = [aws_internet_gateway.igw]
}

# public subnets
resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.public_1_subnet_cidr
  availability_zone = var.az_1
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.public_2_subnet_cidr
  availability_zone = var.az_2
}

# private subnets
resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.private_1_subnet_cidr
  availability_zone = var.az_1
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.private_2_subnet_cidr
  availability_zone = var.az_2
}

# public route tables + association 
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public-rtba-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "public-rtba-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public-rtb.id
}

# private route tables + association 
resource "aws_route_table" "private-rtb-1" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }
}

resource "aws_route_table" "private-rtb-2" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }
}

resource "aws_route_table_association" "private-rtba-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private-rtb-1.id
}

resource "aws_route_table_association" "private-rtba-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private-rtb-2.id
}

