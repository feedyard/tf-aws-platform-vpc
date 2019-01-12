# vpc name for an instance of the platform"
variable "name" {}

# Second octet for IANA private class A network reservation  10.X.0 0
variable "cidr_reservation_start" {}

# default /19 (8192 addresses) network size for a platform instance  10.0.0.0/X
variable "cidr_reservation_size" {
  default = "19"
}

# default reservation offset for a platform instance  10.0.X.0/X
variable "cidr_reservation_offset" {
  default = "0"
}

# default nat subnet size  /22 = 1024 addresses
variable "nat_subnet_size" {
  default = "22"
}

# default starting point for nat subnets in up to four available zones 0f /22
variable "nat_subnet_start" {
  default = ["0", "4", "8", "12"]
}

# default public subnet size  /23 = 512 addresses
variable "public_subnet_size" {
  default = "23"
}

# default starting point for public subnets in up to four available zones 0f /23
variable "public_subnet_start" {
  default = ["16", "18", "20", "22"]
}

# default internal subnet size  /23 = 512 addresses
variable "internal_subnet_size" {
  default = "23"
}

# default starting point for internal subnets in up to four available zones 0f /23
variable "internal_subnet_start" {
  default = ["24", "26", "28", "30"]
}

# list of azs
variable "azs" {
  default = []
}

# should be true to use private DNS within the VPC
variable "enable_dns_hostnames" {
  default = "true"
}

# should be true to use private DNS within the VPC
variable "enable_dns_support" {
  default = "true"
}

# should be true if you do want to auto-assign public IP on launch
variable "map_public_ip_on_launch" {
  default = "false"
}

# A list of VGWs the public route table should propagate.
variable "public_propagating_vgws" {
  default = []
}

# should be true to provision NAT Gateways for each NAT network
variable "enable_nat_gateway" {
  default = "false"
}

# A list of VGWs the private route table should propagate
variable "private_propagating_vgws" {
  default = []
}

# The name of the intendend K8 Cluster
variable "cluster_name" {}

# A map of tags to add to all resources
variable "tags" {
  default = {}
}
