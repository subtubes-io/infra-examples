module "subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.main_vpc_cidr
  networks = [
    { name = "us-west-2a", new_bits = 3 },
    { name = "us-west-2b", new_bits = 3 },
    # { name = "us-west-2c", new_bits = 3 },
    # { name = "us-west-2d", new_bits = 3 },
  ]
}

resource "aws_vpc" "data" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support  = true
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.data.id
}

resource "aws_subnet" "public_subnets" {

  for_each = module.subnet_addrs.network_cidr_blocks
  vpc_id = aws_vpc.data.id
  availability_zone = each.key
  cidr_block        = each.value
  tags = {
    Name = "public ${each.key}"
  }
}



resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.data.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "public_rtassociation" {
  for_each = module.subnet_addrs.network_cidr_blocks
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_eip" "nate_ip" {
  vpc = true
}

#Route table for Private Subnet's
# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.data.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }
# }

# resource "aws_route_table_association" "private_rtassociation" {
#   subnet_id      = aws_subnet.private_subnets.id
#   route_table_id = aws_route_table.private_rt.id
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nate_ip.id
#   subnet_id     = aws_subnet.public_subnets[0]
# }


# resource "aws_subnet" "private_subnets" {

#   availability_zone = "us-west-2a"
#   vpc_id            = aws_vpc.data.id
#   cidr_block        = var.private_subnets
#   tags = {
#     name = "private_1"
#   }
# }