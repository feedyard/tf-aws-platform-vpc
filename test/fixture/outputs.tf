# id of the vpc created
output "vpc_id" {
  value = "${module.cluster_vpc.vpc_id}"
}

# cidr block of vpc created
output "vpc_cidr" {
  value = "${module.cluster_vpc.vpc_cidr}"
}

# list of nat subnet cidr blocks
output "nat_subnet_cidrs" {
  value = ["${module.cluster_vpc.nat_subnet_cidrs}"]
}

# list of nat subnet ids
output "nat_subnet_ids" {
  value = ["${module.cluster_vpc.nat_subnet_ids}"]
}

# list of public subnet cidr blocks
output "public_subnet_cidrs" {
  value = ["${module.cluster_vpc.public_subnet_cidrs}"]
}

# list of public subnet ids
output "public_subnet_ids" {
  value = ["${module.cluster_vpc.public_subnet_ids}"]
}

# list of internal subnet cidr blocks
output "internal_subnet_cidrs" {
  value = ["${module.cluster_vpc.internal_subnet_cidrs}"]
}

# list of internal subnet ids
output "internal_subnet_ids" {
  value = ["${module.cluster_vpc.internal_subnet_ids}"]
}

# db_subnet_group for internal subnet
output "db_subnet_group" {
  value = "${module.cluster_vpc.db_subnet_group}"
}

# internet gateway id
output "igw_id" {
  value = "${module.cluster_vpc.igw_id}"
}

# list of nat gateway internal ip addresses
output "nat_eips" {
  value = ["${module.cluster_vpc.nat_eips}"]
}

# list of net gateway public ip addresses
output "nat_eips_public_ips" {
  value = ["${module.cluster_vpc.nat_eips_public_ips}"]
}

# list of nat gateway ids
output "natgw_ids" {
  value = ["${module.cluster_vpc.natgw_ids}"]
}

output "natgw_objects" {
  value = {
    natgw = "${module.cluster_vpc.natgw_objects}"
  }
}

# list of public routing table ids
output "public_route_table_ids" {
  value = ["${module.cluster_vpc.public_route_table_ids}"]
}

# list of nat routing table ids
output "nat_route_table_ids" {
  value = ["${module.cluster_vpc.nat_route_table_ids}"]
}

# list of internal routing table ids
output "internal_route_table_ids" {
  value = ["${module.cluster_vpc.internal_route_table_ids}"]
}

output "nat_subnet_objects" {
  value = {
    subnet = "${module.cluster_vpc.nat_subnet_objects}"
  }
}

output "public_subnet_objects" {
  value = {
    subnet = "${module.cluster_vpc.public_subnet_objects}"
  }
}

output "internal_subnet_objects" {
  value = {
    subnet = "${module.cluster_vpc.internal_subnet_objects}"
  }
}
