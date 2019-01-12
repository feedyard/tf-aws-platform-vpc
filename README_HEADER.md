# feedyard/tf-aws-platform-vpc

Terraform module to create vpc prepared for platform-configured kubernetes deployment (eks, kops). Prepares a /19  
according to the layout below. However, you can override most setting to create a variety of public/nat/interal  
network configurations.  

## Usage

```
module "cluster_vpc" {
  source = "../../"

  name                   = "${var.cluster_vpc_name}"
  cluster_name           = "${var.cluster_name}"
  cidr_reservation_start = "${var.cluster_cidr_reservation_start}"
  azs                    = "${var.cluster_azs}"

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  enable_nat_gateway   = "${var.cluster_enable_nat_gateway}"

  tags {
    "test"     = "terraform module continuous integration testing"
    "pipeline" = "feedyard/tf-aws-platform-vpc"
  }
}
```

### Structure for account representing an environment instance of a platform

1. Each account is given a /16 (65536)
1. Sub-divided up to eight /19 (8192) VPCs
1. Each VPC sub-divided into two /20 (4069) reservations
1. Each /20 being a platform (k8-and-resources) instance

#### typical single vpc reservations

| /19 | ex:region us-east-1 | az ips | us-east-1b   | us-east-1c     | us-east-1d   | us-east-1e     | subnet ips |
|:---:|---------------------|:------:|--------------|----------------|--------------|----------------|:----------:|
| /23 | subnet-public       | 128    | 10.0.0.0/25  | 10.0.0.128/25  | 10.0.1.0/25  | 10.0.1.128/25  | 512        |
| /23 | (reserved)          | 128    | 10.0.2.0/25  | 10.0.2.128/25  | 10.0.3.0/25  | 10.0.3.128/25  | 512        |
| /21 | subnet-nat          | 512    | 10.0.4.0/23  | 10.0.6.0/23    | 10.0.8.0/23  | 10.0.10.0/23   | 2048       |
| /23 | (reserved)          | 128    | 10.0.12.0/25 | 10.0.12.128/25 | 10.0.13.0/25 | 10.0.13.128/25 | 512        |
| /23 | subnet-internal     | 128    | 10.0.14.0/25 | 10.0.14.128/25 | 10.0.15.0/25 | 10.0.15.128/25 | 512        |
| /20 | (reserved)          |        |              |                |              |                | 4096       |
|     | (total)             |        |              |                |              |                | 8192       |
