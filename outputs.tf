# id of the vpc created
output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}

# cidr block of vpc created
output "vpc_cidr" {
  value = "${aws_vpc.mod.cidr_block}"
}

# list of azs
output "azs" {
  value = "${var.azs}"
}

# list of public subnet cidr blocks
output "public_subnet_cidr" {
  value = "${join(",",aws_subnet.public_subnet.*.cidr_block)}"
}

# list of public subnet ids
output "public_subnet_id" {
  value = "${join(",",aws_subnet.public_subnet.*.id)}"
}

# internet gateway
output "igw_id" {
  value = "${aws_internet_gateway.mod.id}"
}

# list of nat subnet cidr blocks
output "nat_subnet_cidr" {
  value = "${join(",",aws_subnet.nat_subnet.*.cidr_block)}"
}

# list of nat subnet ids
output "nat_subnet_id" {
  value = "${join(",",aws_subnet.nat_subnet.*.id)}"
}

# list of internal subnet cidr blocks
output "internal_subnet_cidr" {
  value = "${join(",",aws_subnet.internal_subnet.*.cidr_block)}"
}

# list of internal subnet ids
output "internal_subnet_id" {
  value = "${join(",",aws_subnet.internal_subnet.*.id)}"
}

# db subnet group for internal subnet
output "db_subnet_group" {
  value = "${aws_db_subnet_group.internal_db_subnet_group.id}"
}

# list of nat gateway internal ip addresses
output "nat_eip" {
  value = "${join(",",aws_eip.nateip.*.id)}"
}

# list of net gateway public ip addresses
output "nat_eips_public_ip" {
  value = "${join(",",aws_eip.nateip.*.public_ip)}"
}

# list of nat gateway ids
output "natgw_id" {
  value = "${join(",",aws_nat_gateway.natgw.*.id)}"
}

output "natgw_objects" {
  value = {
    id = "${aws_nat_gateway.natgw.*.id}"
  }
}

# list of public routing table ids
output "public_route_table_id" {
  value = "${join(",",aws_route_table.public.*.id)}"
}

# list of nat routing table ids
output "nat_route_table_id" {
  value = "${join(",",aws_route_table.nat.*.id)}"
}

# list of internal routing table ids
output "internal_route_table_id" {
  value = "${join(",",aws_route_table.internal.*.id)}"
}

# maps currently used by kops pipeline
output "vpc" {
  value = {
    id   = "${aws_vpc.mod.id}"
    cidr = "${aws_vpc.mod.cidr_block}"
  }
}

# map of nat subnet ids, azs, cidrs, and names
output "nat_subnet_objects" {
  value = {
    id   = "${aws_subnet.nat_subnet.*.id}"
    az   = "${aws_subnet.nat_subnet.*.availability_zone}"
    cidr = "${aws_subnet.nat_subnet.*.cidr_block}"
    name = "${aws_subnet.nat_subnet.*.tags.Name}"
  }
}

# map of public subnet ids, azs, cidrs, and names
output "public_subnet_objects" {
  value = {
    id   = "${aws_subnet.public_subnet.*.id}"
    az   = "${aws_subnet.public_subnet.*.availability_zone}"
    cidr = "${aws_subnet.public_subnet.*.cidr_block}"
    name = "${aws_subnet.public_subnet.*.tags.Name}"
  }
}

# map of internal subnet ids, azs, cidrs, and names
output "internal_subnet_objects" {
  value = {
    id   = "${aws_subnet.internal_subnet.*.id}"
    az   = "${aws_subnet.internal_subnet.*.availability_zone}"
    cidr = "${aws_subnet.internal_subnet.*.cidr_block}"
    name = "${aws_subnet.internal_subnet.*.tags.Name}"
  }
}

# cluster name defined
output "cluster_name" {
  value = {
    name = "${var.cluster_name}"
  }
}
