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
1. Each /19 being a platform (k8-and-resources) instance

#### typical single vpc reservations

|  x3 | on /19 vpc          | max ips | us-east-1b    | us-east-1c      | us-east-1d    |   reserved     | subnet ips |
|:---:|---------------------|:-------:|---------------|-----------------|---------------|----------------|:----------:|
| /21 | subnet-nat          | 6144    | 10.0.0.0/21   | 10.0.8.128/21   | 10.0.16.0/21  |                | 2048       |
| /27 | subnet-public       | 96      | 10.0.24.0/27  | 10.0.24.32/27   | 10.0.24.64/23 |                | 32         |
|     | (reserved)          | 32      |               |                 |               | 10.0.24.96/27  | (32)       |
| /25 | subnet-internal     | 384     | 10.0.25.0/25  | 10.0.25.128/25  | 10.0.26.0/25  |                | 128        |
|     | (reserved)          | 128     |               |                 |               | 10.0.26.128/25 | (128)      |
|     | (reserved)          | 256     |               |                 |               | 10.0.27.0/24   | (256)      |
|     | (reserved)          | 1024    |               |                 |               | 10.0.28.0/22   | (1024)     |
|     | (total)             | 8192    |               |                 |               |                | (1210)     |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azs | list of azs | list | `[]` | no |
| cidr\_class\_a | - | string | `10` | no |
| cidr\_reservation\_offset | default reservation offset for a platform instance  10.0.X.0/X | string | `0` | no |
| cidr\_reservation\_size | default /19 (8192 addresses) network size for a platform instance  10.0.0.0/X | string | `19` | no |
| cidr\_reservation\_start | Second octet for IANA private class A network reservation  10.X.0 0 | string | `0` | no |
| cluster\_name | The name of the intendend K8 Cluster | string | - | yes |
| enable\_dns\_hostnames | should be true to use private DNS within the VPC | string | `true` | no |
| enable\_dns\_support | should be true to use private DNS within the VPC | string | `true` | no |
| enable\_nat\_gateway | should be true to provision NAT Gateways for each NAT network | string | `false` | no |
| internal\_subnet\_offset | default offset (10.0.0.x)  for internal subnets in up to four available zones 0f /25 | list | `[ "25", "25", "26" ]` | no |
| internal\_subnet\_size | default internal subnet size /25 = 128 (x 4 = 512)  addresses | string | `25` | no |
| internal\_subnet\_start | default starting point (10.0.0.x) for internal subnets in up to four available zones 0f /25 | list | `[ "0", "128", "0" ]` | no |
| map\_public\_ip\_on\_launch | should be true if you do want to auto-assign public IP on launch | string | `false` | no |
| name | vpc name for an instance of the platform" | string | - | yes |
| nat\_subnet\_offset | default offset (10.0.0.x)  for nat subnets in up to four available zones 0f /23 | list | `[ "0", "8", "16" ]` | no |
| nat\_subnet\_size | default nat subnet size  /23 = 512 (x 4 = 2048) addresses | string | `21` | no |
| nat\_subnet\_start | default starting point (10.0.0.x) for nat subnets in up to four available zones 0f /23 | list | `[ "0", "0", "0" ]` | no |
| private\_propagating\_vgws | A list of VGWs the private route table should propagate | list | `[]` | no |
| public\_propagating\_vgws | A list of VGWs the public route table should propagate | list | `[]` | no |
| public\_subnet\_offset | default offset (10.0.x.0) for public subnets in up to four available zones of /25 | list | `[ "24", "24", "24" ]` | no |
| public\_subnet\_size | default public subnet size  /25 = 128 (x 4 = 512) addresses | string | `27` | no |
| public\_subnet\_start | default starting point (10.0.0.x) for public subnets in up to four available zones of /25 | list | `[ "0", "32", "64" ]` | no |
| tags | A map of tags to add to all resources | map | `{}` | no |
| transit\_gateway | include transit gateway in nat route | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| azs | list of azs |
| cluster\_name | cluster name defined |
| db\_subnet\_group | db subnet group for internal subnet |
| igw\_id | internet gateway |
| internal\_route\_table\_id | list of internal routing table ids |
| internal\_subnet\_cidr | list of internal subnet cidr blocks |
| internal\_subnet\_id | list of internal subnet ids |
| internal\_subnet\_objects | map of internal subnet ids, azs, cidrs, and names |
| nat\_eip | list of nat gateway internal ip addresses |
| nat\_eips\_public\_ip | list of net gateway public ip addresses |
| nat\_route\_table\_id | list of nat routing table ids |
| nat\_subnet\_cidr | list of nat subnet cidr blocks |
| nat\_subnet\_id | list of nat subnet ids |
| nat\_subnet\_objects | map of nat subnet ids, azs, cidrs, and names |
| natgw\_id | list of nat gateway ids |
| natgw\_objects | - |
| public\_route\_table\_id | list of public routing table ids |
| public\_subnet\_cidr | list of public subnet cidr blocks |
| public\_subnet\_id | list of public subnet ids |
| public\_subnet\_objects | map of public subnet ids, azs, cidrs, and names |
| vpc | maps currently used by kops pipeline |
| vpc\_cidr | cidr block of vpc created |
| vpc\_id | id of the vpc created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->