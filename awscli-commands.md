# 📖 AWS CLI Command Manual for Networking

This manual serves as a comprehensive reference guide for all the AWS CLI commands used in our VPC deployment workshop. For each command, you will find a description, a breakdown of the supported flags, and a sample execution.

All commands here correspond to the **AWS CLI v2**.

---

## 🛠️ Configuration Commands

### `aws configure`
Configures the AWS CLI with your security credentials and default settings.

- **Description**: Prompts you interactively for four pieces of information to authenticate your CLI with your AWS account. This data is saved locally to `~/.aws/credentials`.
- **Interactive Prompts**:
  - `AWS Access Key ID`: Your programmatic access key (e.g., `AKIAIOSFODNN7EXAMPLE`).
  - `AWS Secret Access Key`: The secret string linked to your access key.
  - `Default region name`: The AWS region to send requests to (e.g., `us-east-1`).
  - `Default output format`: The formatting style for command outputs (`json`, `text`, `table`, `yaml`).
- **Sample Command**:
  ```bash
  aws configure
  ```

---

## 🌐 EC2 Networking Commands

*(Note: All VPC and networking commands fall under the `aws ec2` namespace).*

### `aws ec2 create-vpc`
Creates a Virtual Private Cloud (VPC) with the specified IPv4 CIDR block.

- **Description**: Provisions an isolated virtual network environment in the AWS Cloud.
- **Key Flags**:
  - `--cidr-block` *(string)*: The IPv4 network range for the VPC, in CIDR notation (e.g., `10.0.0.0/16`).
  - `--amazon-provided-ipv6-cidr-block` *(boolean flag)*: Requests an Amazon-provided IPv6 CIDR block.
  - `--instance-tenancy` *(string)*: The supported tenancy options for instances launched into the VPC (`default` or `dedicated`).
- **Sample Command**:
  ```bash
  aws ec2 create-vpc --cidr-block 10.0.0.0/16
  ```

### `aws ec2 create-tags`
Adds or overwrites one or more tags for the specified Amazon EC2 resource(s).

- **Description**: Attaches metadata key-value pairs to resources like VPCs, Subnets, and Gateways. Crucial for organizing and identifying resources in the console.
- **Key Flags**:
  - `--resources` *(list of strings)*: The IDs of the resources to tag (e.g., `vpc-12345678`).
  - `--tags` *(list of Key=Value pairs)*: The tags to assign. The format is `Key=string,Value=string`.
- **Sample Command**:
  ```bash
  aws ec2 create-tags --resources vpc-0abcd1234efgh5678 --tags Key=Name,Value=my-vpc
  ```

### `aws ec2 modify-vpc-attribute`
Modifies the specified attribute of the specified VPC.

- **Description**: Changes backend attributes of your VPC, such as enabling automatic DNS hostnames for instances.
- **Key Flags**:
  - `--vpc-id` *(string)*: The ID of the VPC.
  - `--enable-dns-hostnames` *(string/JSON)*: Indicates whether the instances launched in the VPC get DNS hostnames. Pass `{"Value":true}` to enable.
  - `--enable-dns-support` *(string/JSON)*: Indicates whether DNS resolution is supported.
- **Sample Command**:
  ```bash
  aws ec2 modify-vpc-attribute --vpc-id vpc-0abcd1234efgh5678 --enable-dns-hostnames "{\"Value\":true}"
  ```

### `aws ec2 create-subnet`
Creates a subnet in the specified VPC.

- **Description**: Divides your VPC's IP address range into smaller networks that can reside in different physical Availability Zones.
- **Key Flags**:
  - `--vpc-id` *(string)*: The ID of the VPC.
  - `--cidr-block` *(string)*: The IPv4 network range for the subnet, in CIDR notation (e.g., `10.0.1.0/24`).
  - `--availability-zone` *(string)*: The Availability Zone or Local Zone for the subnet (e.g., `us-east-1a`).
- **Sample Command**:
  ```bash
  aws ec2 create-subnet --vpc-id vpc-0abcd1234efgh5678 --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
  ```

### `aws ec2 modify-subnet-attribute`
Modifies a subnet attribute.

- **Description**: Often used to change whether a subnet is considered "public" by automatically assigning public IPs to instances launched within it.
- **Key Flags**:
  - `--subnet-id` *(string)*: The ID of the subnet.
  - `--map-public-ip-on-launch` *(boolean flag)*: If specified, indicates that instances launched in this subnet automatically receive a public IPv4 address.
- **Sample Command**:
  ```bash
  aws ec2 modify-subnet-attribute --subnet-id subnet-0123456789abcdef0 --map-public-ip-on-launch
  ```

### `aws ec2 create-internet-gateway`
Creates an internet gateway for use with a VPC.

- **Description**: Provisions a redundant, highly available gateway that allows communication between your VPC and the internet.
- **Key Flags**: None required for basic creation.
- **Sample Command**:
  ```bash
  aws ec2 create-internet-gateway
  ```

### `aws ec2 attach-internet-gateway`
Attaches an internet gateway to a VPC.

- **Description**: Hooks up the newly created Internet Gateway to your specific VPC.
- **Key Flags**:
  - `--internet-gateway-id` *(string)*: The ID of the internet gateway.
  - `--vpc-id` *(string)*: The ID of the VPC.
- **Sample Command**:
  ```bash
  aws ec2 attach-internet-gateway --vpc-id vpc-0abcd1234efgh5678 --internet-gateway-id igw-0123456789abcdef0
  ```

### `aws ec2 describe-route-tables`
Describes one or more of your route tables. 

- **Description**: Queries AWS for details about your route tables. In this lab, we use it to find the default (main) route table that is automatically created with the VPC.
- **Key Flags**:
  - `--filters` *(list of strings)*: The filters to narrow down the search. Format is `Name=string,Values=string,string`.
  - `--query` *(string)*: A JMESPath query to filter the JSON output to exact data fields (e.g., just the Route Table ID).
  - `--output` *(string)*: The formatting style for the output (`json`, `text`, `table`).
- **Sample Command**:
  ```bash
  aws ec2 describe-route-tables --filters Name=vpc-id,Values=vpc-0abcd1234efgh5678 Name=association.main,Values=true --query 'RouteTables[0].RouteTableId' --output text
  ```

### `aws ec2 create-route-table`
Creates a new route table for the specified VPC.

- **Description**: Provisions an empty routing table that you can populate with custom routing rules (like directing traffic to an Internet Gateway).
- **Key Flags**:
  - `--vpc-id` *(string)*: The ID of the VPC.
- **Sample Command**:
  ```bash
  aws ec2 create-route-table --vpc-id vpc-0abcd1234efgh5678
  ```

### `aws ec2 create-route`
Creates a route in a route table within a VPC.

- **Description**: Adds a directional rule to a route table. For example, routing all internet-bound traffic (`0.0.0.0/0`) to the Internet Gateway.
- **Key Flags**:
  - `--route-table-id` *(string)*: The ID of the route table for the route.
  - `--destination-cidr-block` *(string)*: The IPv4 CIDR address block used for the destination match (`0.0.0.0/0` matches all external traffic).
  - `--gateway-id` *(string)*: The ID of the internet gateway (or virtual private gateway) where matching traffic should be sent.
- **Sample Command**:
  ```bash
  aws ec2 create-route --route-table-id rtb-0123456789abcdef0 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0123456789abcdef0
  ```

### `aws ec2 associate-route-table`
Associates a subnet in your VPC with a route table. 

- **Description**: Links a subnet to a specific route table, overriding the VPC's main route table. This dictates the routing rules for all resources within that subnet.
- **Key Flags**:
  - `--subnet-id` *(string)*: The ID of the subnet.
  - `--route-table-id` *(string)*: The ID of the route table.
- **Sample Command**:
  ```bash
  aws ec2 associate-route-table --subnet-id subnet-0123456789abcdef0 --route-table-id rtb-0123456789abcdef0
  ```

---
[⬅️ Back to Main README](./README.md)
