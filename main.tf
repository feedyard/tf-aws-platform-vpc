resource "aws_vpc" "mod" {
  cidr_block           = "${var.cidr_class_a}.${var.cidr_reservation_start}.${var.cidr_reservation_offset}.0/${var.cidr_reservation_size}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(var.tags, map("Name", format("%s", var.name)), map("Cluster", format("%s", var.cluster_name)), map(format("kubernetes.io/cluster/%s",var.cluster_name),"shared"))}"
}

# public subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.mod.id}"
  cidr_block              = "${var.cidr_class_a}.${var.cidr_reservation_start}.${var.public_subnet_offset[count.index]}.${var.public_subnet_start[count.index]}/${var.public_subnet_size}"
  availability_zone       = "${element(var.azs, count.index)}"
  count                   = "${length(var.azs)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  tags                    = "${merge(var.tags, map("Tier", "public"), map("Name", format("subnet-%s-public-%s", var.name, element(var.azs, count.index))), map(format("kubernetes.io/cluster/%s",var.cluster_name),"shared"))}"
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"
  tags   = "${merge(var.tags, map("Name", format("%s-igw", var.name)), map(format("kubernetes.io/cluster/%s",var.cluster_name),"shared"))}"
}

resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.mod.id}"
  propagating_vgws = ["${var.public_propagating_vgws}"]
  tags             = "${merge(var.tags, map("Name", format("%s-rt-public", var.name)))}"
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mod.id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

# nat subnets
resource "aws_subnet" "nat_subnet" {
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${var.cidr_class_a}.${var.cidr_reservation_start}.${var.nat_subnet_offset[count.index]}.${var.nat_subnet_start[count.index]}/${var.nat_subnet_size}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.azs)}"
  tags              = "${merge(var.tags, map("Tier", "nat"), map("Name", format("subnet-%s-nat-%s", var.name, element(var.azs, count.index))), map(format("kubernetes.io/cluster/%s",var.cluster_name),"shared"), map("kubernetes.io/role/internal-elb","1"))}"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${element(aws_eip.nateip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  count         = "${length(var.azs) * lookup(map(var.enable_nat_gateway, 1), "true", 0)}"
  tags          = "${merge(var.tags,map(format("kubernetes.io/cluster/%s",var.cluster_name),"shared"))}"

  depends_on = ["aws_internet_gateway.mod"]
}

resource "aws_eip" "nateip" {
  vpc   = "true"
  count = "${length(var.azs) * lookup(map(var.enable_nat_gateway, 1), "true", 0)}"
}

resource "aws_route_table" "nat" {
  vpc_id           = "${aws_vpc.mod.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]
  count            = "${length(var.azs)}"
  tags             = "${merge(var.tags, map("Name", format("%s-rt-nat-%s", var.name, element(var.azs, count.index))), map(format("kubernetes.io/cluster/%s",var.cluster_name),"shared"))}"
}

resource "aws_route" "nat_gateway" {
  route_table_id         = "${element(aws_route_table.nat.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  count                  = "${length(var.azs) * lookup(map(var.enable_nat_gateway, 1), "true", 0)}"

  depends_on = ["aws_route_table.nat"]
}

//resource "aws_route" "transit_gateway" {
//  route_table_id         = "${element(aws_route_table.nat.*.id, count.index)}"
//  destination_cidr_block = "10.0.0.0/8"
//  transit_gateway_id     = "${var.transit_gateway}"
//  count                  = "${var.transit_gateway == "" ? 0 : length(var.azs)}"
//
//  depends_on = ["aws_route_table.nat"]
//}

data "aws_subnet_ids" "nat_subnet" {
  vpc_id = "${aws_vpc.mod.id}"

  tags = {
    Tier = "nat"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "nat_subnet" {
  count                                           = "${var.transit_gateway == "" ? 0 : 1}"
  vpc_id                                          = "${aws_vpc.mod.id}"
  subnet_ids                                      = ["${data.aws_subnet_ids.nat_subnet.ids}"]
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"
  transit_gateway_id                              = "${var.transit_gateway}"
}

resource "aws_route_table_association" "nat_subnet" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.nat_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.nat.*.id, count.index)}"

  depends_on = ["aws_route_table.nat"]
}

# internal subnets
resource "aws_subnet" "internal_subnet" {
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${var.cidr_class_a}.${var.cidr_reservation_start}.${var.internal_subnet_offset[count.index]}.${var.internal_subnet_start[count.index]}/${var.internal_subnet_size}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.azs)}"
  tags              = "${merge(var.tags, map("Tier", "internal"), map("Name", format("subnet-%s-internal-%s", var.name, element(var.azs, count.index))), map(format("kubernetes.io/cluster/%s",var.cluster_name),"shared"))}"
}

resource "aws_route_table" "internal" {
  vpc_id           = "${aws_vpc.mod.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]
  count            = "${length(var.azs)}"
  tags             = "${merge(var.tags, map("Name", format("%s-rt-internal-%s", var.name, element(var.azs, count.index))), map(format("kubernetes.io/cluster/%s",var.cluster_name),"shared"))}"
}

resource "aws_route_table_association" "internal" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.internal_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.internal.*.id, count.index)}"
}

resource "aws_db_subnet_group" "internal_db_subnet_group" {
  name       = "${var.name}_db_subnet_group"
  subnet_ids = ["${aws_subnet.internal_subnet.*.id}"]
  tags       = "${merge(var.tags, map("Name", format("%s-db-subnet-group", var.name)))}"
}
