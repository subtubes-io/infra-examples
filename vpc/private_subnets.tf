module "subnet_addrs_private" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.private_subnets
  networks = [
    { name = "us-west-2a", new_bits = 3 },
    { name = "us-west-2b", new_bits = 3 },
  ]
}



resource "aws_subnet" "private_subnets" {

  for_each          = module.subnet_addrs_private.network_cidr_blocks
  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value
  tags = {
    Name = "private ${each.key}"
  }
}

resource "aws_eip" "nat_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnets["us-west-2a"].id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private_rtassociation" {
  for_each       = module.subnet_addrs_private.network_cidr_blocks
  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.private_rt.id
}
