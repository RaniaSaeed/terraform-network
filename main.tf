resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = {
    Name = var.vpcname
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.sub1cidr
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public"
  }
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id

}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.sub2cidr
  map_public_ip_on_launch = "true"

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private"
  }
}


resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "byoip-ip" {
  domain           = "vpc"
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.byoip-ip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "terraform"
  }

}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.example.id

}