resource "aws_vpc" "this" { #vpc
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "upgrad-vpc"
  }
}

# 2public and 2 private subnets
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.100.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "upgrad-public-1"
    Project = "upGrad"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.100.2.0/24"

  tags = {
    Name = "upgrad-public-2"
    Project = "upGrad"
  }
}
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.100.3.0/24"

  tags = {
    Name = "upgrad-private-1"
    Project = "upGrad"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.100.4.0/24"

  tags = {
    Name = "upgrad-private-2"
    Project = "upGrad"
  }
}

#Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "upgrad-igw"
  }
}
resource "aws_eip" "eip" {
  vpc      = true
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "upgrad-nat"
  }
}

#Route tables 1-public, 1private
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "upgrad-public"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "upgrad-private"
  }
}

#route table assoiation for each subnets
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}