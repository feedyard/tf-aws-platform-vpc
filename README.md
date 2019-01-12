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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azs | list of azs | list | `<list>` | no |
| cidr\_reservation\_offset | default reservation offset for a platform instance  10.0.X.0/X | string | `0` | no |
| cidr\_reservation\_size | default /19 (8192 addresses) network size for a platform instance  10.0.0.0/X | string | `19` | no |
| cidr\_reservation\_start | Second octet for IANA private class A network reservation  10.X.0 0 | string | - | yes |
| cluster\_name | The name of the intendend K8 Cluster | string | - | yes |
| enable\_dns\_hostnames | should be true to use private DNS within the VPC | string | `true` | no |
| enable\_dns\_support | should be true to use private DNS within the VPC | string | `true` | no |
| enable\_nat\_gateway | should be true to provision NAT Gateways for each NAT network | string | `false` | no |
| internal\_subnet\_size | default internal subnet size  /23 = 512 addresses | string | `23` | no |
| internal\_subnet\_start | default starting point for internal subnets in up to four available zones 0f /23 | list | `<list>` | no |
| map\_public\_ip\_on\_launch | should be true if you do want to auto-assign public IP on launch | string | `false` | no |
| name | vpc name for an instance of the platform" | string | - | yes |
| nat\_subnet\_size | default nat subnet size  /22 = 1024 addresses | string | `22` | no |
| nat\_subnet\_start | default starting point for nat subnets in up to four available zones 0f /22 | list | `<list>` | no |
| private\_propagating\_vgws | A list of VGWs the private route table should propagate | list | `<list>` | no |
| public\_propagating\_vgws | A list of VGWs the public route table should propagate. | list | `<list>` | no |
| public\_subnet\_size | default public subnet size  /23 = 512 addresses | string | `23` | no |
| public\_subnet\_start | default starting point for public subnets in up to four available zones 0f /23 | list | `<list>` | no |
| tags | A map of tags to add to all resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| azs | list of azs |
| cluster\_name | - |
| db\_subnet\_group | db subnet group for internal subnet |
| igw\_id | internet gateway |
| internal\_route\_table\_ids | list of internal routing table ids |
| internal\_subnet\_cidrs | list of internal subnet cidr blocks |
| internal\_subnet\_ids | list of internal subnet ids |
| internal\_subnet\_objects | - |
| nat\_eips | list of nat gateway internal ip addresses |
| nat\_eips\_public\_ips | list of net gateway public ip addresses |
| nat\_route\_table\_ids | list of nat routing table ids |
| nat\_subnet\_cidrs | list of nat subnet cidr blocks |
| nat\_subnet\_ids | list of nat subnet ids |
| nat\_subnet\_objects | - |
| natgw\_ids | list of nat gateway ids |
| natgw\_objects | - |
| public\_route\_table\_ids | list of public routing table ids |
| public\_subnet\_cidrs | list of public subnet cidr blocks |
| public\_subnet\_ids | list of public subnet ids |
| public\_subnet\_objects | - |
| vpc | maps currently used by kops pipeline |
| vpc\_cidr | cidr block of vpc created |
| vpc\_id | id of the vpc created |

