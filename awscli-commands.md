# 📖 AWS CLI Command Manual (A to Z Core Services)

This manual serves as a comprehensive reference guide for the most critical and frequently used AWS CLI commands across major AWS services from A to Z. 

For each command, you will find a description, a breakdown of the supported flags, and a sample execution. All commands correspond to the **AWS CLI v2**.

---

## 🛠️ Configuration Commands

### `aws configure`
Configures the AWS CLI with your security credentials and default settings.
- **Description**: Prompts you interactively for four pieces of information to authenticate your CLI.
- **Interactive Prompts**:
  - `AWS Access Key ID`: Your programmatic access key (e.g., `AKIAIOSFODNN7EXAMPLE`).
  - `AWS Secret Access Key`: The secret string linked to your access key.
  - `Default region name`: The AWS region to send requests to (e.g., `us-east-1`).
  - `Default output format`: The formatting style (`json`, `text`, `table`).
- **Sample Command**:
  ```bash
  aws configure
  ```

---

## 🅰️ Auto Scaling (`aws autoscaling`)

### `aws autoscaling create-auto-scaling-group`
Creates an Auto Scaling group to automatically manage the number of EC2 instances.
- **Key Flags**:
  - `--auto-scaling-group-name` *(string)*: The name of the group.
  - `--min-size` *(integer)*: The minimum size of the group.
  - `--max-size` *(integer)*: The maximum size of the group.
  - `--vpc-zone-identifier` *(string)*: A comma-separated list of subnet IDs.
- **Sample Command**:
  ```bash
  aws autoscaling create-auto-scaling-group --auto-scaling-group-name my-asg --min-size 1 --max-size 5 --vpc-zone-identifier "subnet-12345,subnet-67890"
  ```

---

## ☁️ CloudFormation (`aws cloudformation`)

### `aws cloudformation create-stack`
Deploys a new AWS architecture from an Infrastructure-as-Code template.
- **Key Flags**:
  - `--stack-name` *(string)*: The name associated with the stack.
  - `--template-body` *(string)*: The structure containing the template body.
- **Sample Command**:
  ```bash
  aws cloudformation create-stack --stack-name my-vpc-stack --template-body file://template.yaml
  ```

---

## 📊 CloudWatch (`aws cloudwatch`)

### `aws cloudwatch put-metric-alarm`
Creates or updates an alarm and associates it with the specified metric.
- **Key Flags**:
  - `--alarm-name` *(string)*: The name for the alarm.
  - `--metric-name` *(string)*: The name of the metric associated with the alarm (e.g., `CPUUtilization`).
  - `--namespace` *(string)*: The namespace for the metric (e.g., `AWS/EC2`).
  - `--statistic` *(string)*: The statistic for the metric (e.g., `Average`).
- **Sample Command**:
  ```bash
  aws cloudwatch put-metric-alarm --alarm-name HighCPU --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --threshold 80 --comparison-operator GreaterThanThreshold --evaluation-periods 2
  ```

---

## ⚡ DynamoDB (`aws dynamodb`)

### `aws dynamodb create-table`
Creates a new NoSQL database table.
- **Key Flags**:
  - `--table-name` *(string)*: The name of the table to create.
  - `--attribute-definitions` *(list)*: An array of attributes that describe the key schema for the table.
  - `--key-schema` *(list)*: Specifies the attributes that make up the primary key.
  - `--billing-mode` *(string)*: Controls how you are charged (`PROVISIONED` or `PAY_PER_REQUEST`).
- **Sample Command**:
  ```bash
  aws dynamodb create-table --table-name Users --attribute-definitions AttributeName=UserId,AttributeType=S --key-schema AttributeName=UserId,KeyType=HASH --billing-mode PAY_PER_REQUEST
  ```

---

## 💻 EC2 & VPC (`aws ec2`)

### `aws ec2 run-instances`
Launches one or more EC2 instances (virtual servers).
- **Key Flags**:
  - `--image-id` *(string)*: The ID of the AMI to use (e.g., `ami-0abcdef1234567890`).
  - `--count` *(integer)*: Number of instances to launch.
  - `--instance-type` *(string)*: The instance type (e.g., `t2.micro`).
  - `--key-name` *(string)*: The name of the SSH key pair.
- **Sample Command**:
  ```bash
  aws ec2 run-instances --image-id ami-0abcdef1234567890 --count 1 --instance-type t2.micro --key-name my-key-pair
  ```

### `aws ec2 create-vpc`
Creates a Virtual Private Cloud (VPC) with the specified IPv4 CIDR block.
- **Key Flags**:
  - `--cidr-block` *(string)*: The IPv4 network range for the VPC, in CIDR notation (e.g., `10.0.0.0/16`).
  - `--amazon-provided-ipv6-cidr-block` *(boolean)*: Requests an Amazon-provided IPv6 CIDR block.
- **Sample Command**:
  ```bash
  aws ec2 create-vpc --cidr-block 10.0.0.0/16
  ```

### `aws ec2 create-tags`
Adds or overwrites one or more tags for the specified Amazon EC2 resource(s).
- **Key Flags**:
  - `--resources` *(list)*: The IDs of the resources to tag (e.g., `vpc-12345678`).
  - `--tags` *(list)*: The tags to assign. The format is `Key=string,Value=string`.
- **Sample Command**:
  ```bash
  aws ec2 create-tags --resources vpc-0abcd1234efgh5678 --tags Key=Name,Value=my-vpc
  ```

### `aws ec2 modify-vpc-attribute`
Modifies the specified attribute of the specified VPC.
- **Key Flags**:
  - `--vpc-id` *(string)*: The ID of the VPC.
  - `--enable-dns-hostnames` *(string/JSON)*: Indicates whether instances get DNS hostnames. Pass `{"Value":true}` to enable.
- **Sample Command**:
  ```bash
  aws ec2 modify-vpc-attribute --vpc-id vpc-0abcd1234efgh5678 --enable-dns-hostnames "{\"Value\":true}"
  ```

### `aws ec2 create-subnet`
Creates a subnet in the specified VPC.
- **Key Flags**:
  - `--vpc-id` *(string)*: The ID of the VPC.
  - `--cidr-block` *(string)*: The IPv4 network range for the subnet.
  - `--availability-zone` *(string)*: The Availability Zone (e.g., `us-east-1a`).
- **Sample Command**:
  ```bash
  aws ec2 create-subnet --vpc-id vpc-0abcd1234efgh5678 --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
  ```

### `aws ec2 modify-subnet-attribute`
Modifies a subnet attribute.
- **Key Flags**:
  - `--subnet-id` *(string)*: The ID of the subnet.
  - `--map-public-ip-on-launch` *(boolean flag)*: If specified, instances automatically receive a public IPv4 address.
- **Sample Command**:
  ```bash
  aws ec2 modify-subnet-attribute --subnet-id subnet-0123456789abcdef0 --map-public-ip-on-launch
  ```

### `aws ec2 create-internet-gateway`
Creates an internet gateway for use with a VPC.
- **Sample Command**:
  ```bash
  aws ec2 create-internet-gateway
  ```

### `aws ec2 attach-internet-gateway`
Attaches an internet gateway to a VPC.
- **Key Flags**:
  - `--internet-gateway-id` *(string)*: The ID of the internet gateway.
  - `--vpc-id` *(string)*: The ID of the VPC.
- **Sample Command**:
  ```bash
  aws ec2 attach-internet-gateway --vpc-id vpc-0abcd1234efgh5678 --internet-gateway-id igw-0123456789abcdef0
  ```

### `aws ec2 describe-route-tables`
Describes one or more of your route tables.
- **Key Flags**:
  - `--filters` *(list)*: The filters to narrow down the search (e.g. `Name=vpc-id,Values=...`).
  - `--query` *(string)*: A JMESPath query to filter the JSON output.
  - `--output` *(string)*: Formatting style (`json`, `text`, `table`).
- **Sample Command**:
  ```bash
  aws ec2 describe-route-tables --filters Name=vpc-id,Values=vpc-0abcd1234efgh5678 Name=association.main,Values=true --query 'RouteTables[0].RouteTableId' --output text
  ```

### `aws ec2 create-route-table`
Creates a new route table for the specified VPC.
- **Key Flags**:
  - `--vpc-id` *(string)*: The ID of the VPC.
- **Sample Command**:
  ```bash
  aws ec2 create-route-table --vpc-id vpc-0abcd1234efgh5678
  ```

### `aws ec2 create-route`
Creates a route in a route table.
- **Key Flags**:
  - `--route-table-id` *(string)*: The ID of the route table.
  - `--destination-cidr-block` *(string)*: The IPv4 CIDR block used for destination match (`0.0.0.0/0` matches all external traffic).
  - `--gateway-id` *(string)*: The ID of the internet gateway.
- **Sample Command**:
  ```bash
  aws ec2 create-route --route-table-id rtb-0123456789abcdef0 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0123456789abcdef0
  ```

### `aws ec2 associate-route-table`
Associates a subnet in your VPC with a route table.
- **Key Flags**:
  - `--subnet-id` *(string)*: The ID of the subnet.
  - `--route-table-id` *(string)*: The ID of the route table.
- **Sample Command**:
  ```bash
  aws ec2 associate-route-table --subnet-id subnet-0123456789abcdef0 --route-table-id rtb-0123456789abcdef0
  ```

---

## ☸️ Elastic Kubernetes Service (`aws eks`)

### `aws eks create-cluster`
Creates an Amazon EKS control plane.
- **Key Flags**:
  - `--name` *(string)*: The unique name to give to your cluster.
  - `--role-arn` *(string)*: The Amazon Resource Name (ARN) of the IAM role that provides permissions for the cluster.
  - `--resources-vpc-config` *(string)*: The VPC configuration used by the cluster control plane.
- **Sample Command**:
  ```bash
  aws eks create-cluster --name my-cluster --role-arn arn:aws:iam::111122223333:role/eks-role --resources-vpc-config subnetIds=subnet-1,subnet-2
  ```

---

## 🔑 Identity and Access Management (`aws iam`)

### `aws iam create-user`
Creates a new IAM user for your AWS account.
- **Key Flags**:
  - `--user-name` *(string)*: The name of the user to create.
- **Sample Command**:
  ```bash
  aws iam create-user --user-name my-new-developer
  ```

### `aws iam attach-user-policy`
Attaches a managed policy to a user, granting them specific permissions.
- **Key Flags**:
  - `--user-name` *(string)*: The name of the user.
  - `--policy-arn` *(string)*: The Amazon Resource Name (ARN) of the IAM policy you want to attach.
- **Sample Command**:
  ```bash
  aws iam attach-user-policy --user-name my-new-developer --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
  ```

---

## 🛡️ Key Management Service (`aws kms`)

### `aws kms create-key`
Creates a unique customer managed KMS key for encryption.
- **Key Flags**: None strictly required for a basic symmetric key.
- **Sample Command**:
  ```bash
  aws kms create-key --description "My root encryption key"
  ```

---

## ƛ Lambda (`aws lambda`)

### `aws lambda create-function`
Creates a serverless compute function.
- **Key Flags**:
  - `--function-name` *(string)*: The name of the Lambda function.
  - `--runtime` *(string)*: The identifier of the function's runtime (e.g., `python3.9`).
  - `--role` *(string)*: The ARN of the function's execution role.
  - `--handler` *(string)*: The name of the method within your code that Lambda calls to execute your function.
  - `--zip-file` *(string)*: The path to the zip file of your code.
- **Sample Command**:
  ```bash
  aws lambda create-function --function-name my-func --runtime python3.9 --role arn:aws:iam::123:role/lambda-role --handler app.handler --zip-file fileb://function.zip
  ```

---

## 🗄️ Relational Database Service (`aws rds`)

### `aws rds create-db-instance`
Creates a new managed relational database instance.
- **Key Flags**:
  - `--db-instance-identifier` *(string)*: The DB instance identifier.
  - `--db-instance-class` *(string)*: The compute and memory capacity of the DB instance (e.g., `db.t3.micro`).
  - `--engine` *(string)*: The name of the database engine (e.g., `mysql`, `postgres`).
  - `--master-username` *(string)*: The name for the master user.
  - `--master-user-password` *(string)*: The password for the master user.
- **Sample Command**:
  ```bash
  aws rds create-db-instance --db-instance-identifier mydb --db-instance-class db.t3.micro --engine postgres --master-username admin --master-user-password mysecurepass123 --allocated-storage 20
  ```

---

## 🪣 Simple Storage Service (`aws s3`)

*(Note: S3 has a high-level `aws s3` namespace and a low-level API `aws s3api` namespace).*

### `aws s3 mb`
Makes a new S3 bucket.
- **Argument**:
  - The `s3://` URI of the bucket to create. Bucket names must be globally unique.
- **Sample Command**:
  ```bash
  aws s3 mb s3://my-globally-unique-bucket-name-1234
  ```

### `aws s3 cp`
Copies a local file or S3 object to another location.
- **Arguments**:
  - Source path (local or `s3://...`).
  - Destination path (local or `s3://...`).
- **Sample Command**:
  ```bash
  aws s3 cp my-document.pdf s3://my-globally-unique-bucket-name-1234/
  ```

### `aws s3 sync`
Syncs directories and S3 prefixes recursively.
- **Arguments**:
  - Source path and destination path.
- **Sample Command**:
  ```bash
  aws s3 sync ./my-local-folder s3://my-website-bucket/
  ```

---
[⬅️ Back to Main README](./README.md)
