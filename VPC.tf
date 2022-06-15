#Create the VPC
resource "aws_vpc" "Ivan_VPC" {
  cidr_block = var.vpc_net

  tags = {
    Name = "VPC_Ivan"
  }
}

#Create the private subnet
resource "aws_subnet" "private" {
  cidr_block              = var.private_cidr
  vpc_id                  = aws_vpc.Ivan_VPC.id
  map_public_ip_on_launch = false

  tags = {
    Name = "Private"
  }
}

#Create the public subnet
resource "aws_subnet" "public" {
  cidr_block              = var.public_cidr
  vpc_id                  = aws_vpc.Ivan_VPC.id
  map_public_ip_on_launch = true

  tags = {
    Name = "Public"
  }
}

#Create the Internet GW for the public subnet
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.Ivan_VPC.id

  tags = {
    Name = "Internet Gateway for Ivan_VPC"
  }
}

#Create route to internet for private subnet via NAT GW
resource "aws_route" "throug_nat_gw" {
  route_table_id         = aws_vpc.Ivan_VPC.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

#Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "gw_ip_nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.gw_ip_nat.id
  depends_on    = [aws_internet_gateway.internet_gw]
}

#Explicitly associate private subnet to the main
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_vpc.Ivan_VPC.main_route_table_id
}

#Create a new route table for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Ivan_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
  tags = {
    Name = "Public"
  }
}

# Explicitly associate the newly created route tables to the public subnets so it does not use the default one 
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}