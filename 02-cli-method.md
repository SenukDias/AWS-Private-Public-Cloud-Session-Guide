# 🚀 CLI Method: AWS Command Line Interface (Step-by-Step)

This guide walks you through deploying the bifurcated VPC architecture entirely using the AWS Command Line Interface (CLI). 

To ensure this is easy for beginners, we will explore **every single command**, starting from installation, and break down exactly what each keyword and flag does.

---

## 🛠️ Step 0: Installing and Configuring AWS CLI

Before interacting with AWS from your terminal, you need the official AWS CLI installed and configured.

### 1. Install the AWS CLI

**For Linux / macOS:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
**Command Breakdown:**
- `curl`: A tool to download files from the internet.
- `"https://..."`: The official download link for the AWS CLI v2 package.
- `-o "awscliv2.zip"`: Saves the downloaded file as `awscliv2.zip`.
- `unzip`: Extracts the contents of the zip file.
- `sudo`: Runs the command with administrator (root) privileges.
- `./aws/install`: Executes the official installation script that puts AWS CLI in your system's path.

*(For Windows, download and run the MSI installer from the [official AWS docs](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).)*

### 2. Configure AWS Credentials
Once installed, you must link the CLI to your AWS account.
```bash
aws configure
```
**What happens here?**
You will be prompted to enter four pieces of information:
- **AWS Access Key ID**: Your programmatic access key (looks like `AKIAIOSFODNN7EXAMPLE`).
- **AWS Secret Access Key**: The secret password for your access key.
- **Default region name**: Where your resources will be created by default (e.g., `us-east-1`).
- **Default output format**: How the CLI returns data to you (type `json`).

---

## 🏗️ Step 1: Create the VPC

First, we create the Virtual Private Cloud (VPC), which acts as our isolated network boundary.

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```
**Command Breakdown:**
- `aws`: The base command to interact with the AWS CLI.
- `ec2`: The AWS service we are interacting with. (Networking resources like VPCs fall under EC2).
- `create-vpc`: The specific action we want to perform.
- `--cidr-block`: A flag that defines the IP address range for our network.
- `10.0.0.0/16`: Provides 65,536 private IP addresses for our entire VPC.

*(Note: When you run this, AWS will output a JSON block containing your `"VpcId"` (e.g., `vpc-0abcd1234efgh5678`). You will need to copy this ID for the next steps!)*

### Tagging the VPC
```bash
aws ec2 create-tags --resources <YOUR_VPC_ID> --tags Key=Name,Value=my-bifurcated-vpc
```
**Command Breakdown:**
- `create-tags`: The action to add metadata (tags) to an AWS resource.
- `--resources`: Specifies which resource gets the tag. Replace `<YOUR_VPC_ID>` with the ID from the previous step.
- `--tags`: Defines the tag to add.
- `Key=Name,Value=my-bifurcated-vpc`: We create a key named "Name" and assign it the value "my-bifurcated-vpc". This is how resources get named in the AWS Console.

### Enable DNS Hostnames
```bash
aws ec2 modify-vpc-attribute --vpc-id <YOUR_VPC_ID> --enable-dns-hostnames "{\"Value\":true}"
```
**Command Breakdown:**
- `modify-vpc-attribute`: Changes a setting on the VPC.
- `--vpc-id`: Specifies which VPC to modify.
- `--enable-dns-hostnames`: The specific setting we are turning on.
- `"{\"Value\":true}"`: A JSON string explicitly telling AWS to set this value to `true`. This allows EC2 instances inside the VPC to receive public DNS names.

---

## 🌐 Step 2: Create Subnets

We will divide our VPC into two subnets: one Public and one Private.

### Create the Public Subnet
```bash
aws ec2 create-subnet --vpc-id <YOUR_VPC_ID> --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
```
**Command Breakdown:**
- `create-subnet`: The action to create a sub-network.
- `--vpc-id`: The VPC this subnet will live inside.
- `--cidr-block 10.0.1.0/24`: Allocates 256 IP addresses from our main VPC specifically for this subnet.
- `--availability-zone us-east-1a`: Forces the subnet to exist in a specific physical data center zone.

*(Copy the `"SubnetId"` from the output for the public subnet).*

### Tag and Configure the Public Subnet
```bash
aws ec2 create-tags --resources <PUBLIC_SUBNET_ID> --tags Key=Name,Value=public-subnet-1
aws ec2 modify-subnet-attribute --subnet-id <PUBLIC_SUBNET_ID> --map-public-ip-on-launch
```
**Command Breakdown:**
- `modify-subnet-attribute`: Changes a setting on the subnet.
- `--map-public-ip-on-launch`: This is the magic flag that makes this subnet "Public." It ensures any EC2 instance launched here automatically gets a public IP address so the internet can reach it.

### Create the Private Subnet
```bash
aws ec2 create-subnet --vpc-id <YOUR_VPC_ID> --cidr-block 10.0.2.0/24 --availability-zone us-east-1a
aws ec2 create-tags --resources <PRIVATE_SUBNET_ID> --tags Key=Name,Value=private-subnet-1
```
*(Copy the `"SubnetId"` from the output for the private subnet. Notice we do **not** run the `--map-public-ip-on-launch` command for this subnet).*

---

## 🚪 Step 3: Create and Attach the Internet Gateway

For resources in our public subnet to talk to the internet, our VPC needs an Internet Gateway (IGW).

### Create the IGW
```bash
aws ec2 create-internet-gateway
```
*(Copy the `"InternetGatewayId"` from the output).*

### Tag and Attach the IGW
```bash
aws ec2 create-tags --resources <IGW_ID> --tags Key=Name,Value=my-igw
aws ec2 attach-internet-gateway --vpc-id <YOUR_VPC_ID> --internet-gateway-id <IGW_ID>
```
**Command Breakdown:**
- `attach-internet-gateway`: Plugs the Internet Gateway we just created into our VPC.
- `--internet-gateway-id`: Specifies the exact gateway to attach.

---

## 🗺️ Step 4: Configure Route Tables

A route table acts as a map, telling network traffic where it is allowed to go.

### Tag the Private Route Table
When you create a VPC, AWS automatically creates a "Main" route table. We will use this as our private route table. First, find its ID:
```bash
aws ec2 describe-route-tables --filters Name=vpc-id,Values=<YOUR_VPC_ID> Name=association.main,Values=true
```
*(Find `"RouteTableId"` in the output and copy it).*
```bash
aws ec2 create-tags --resources <MAIN_ROUTE_TABLE_ID> --tags Key=Name,Value=private-route-table
```

### Create the Public Route Table
Since the public subnet needs a different map (one that includes the internet), we create a new route table.
```bash
aws ec2 create-route-table --vpc-id <YOUR_VPC_ID>
```
*(Copy the new `"RouteTableId"`).*
```bash
aws ec2 create-tags --resources <PUBLIC_ROUTE_TABLE_ID> --tags Key=Name,Value=public-route-table
```

### Add the Internet Route
Now we update the public route table to map traffic to the Internet Gateway.
```bash
aws ec2 create-route --route-table-id <PUBLIC_ROUTE_TABLE_ID> --destination-cidr-block 0.0.0.0/0 --gateway-id <IGW_ID>
```
**Command Breakdown:**
- `create-route`: Adds a new directional rule to a route table.
- `--route-table-id`: The specific route table we are modifying.
- `--destination-cidr-block 0.0.0.0/0`: The IP address destination. `0.0.0.0/0` represents "everywhere" or the entire external internet.
- `--gateway-id`: Where to send traffic destined for the internet. We send it to our IGW.

### Associate the Route Table with the Public Subnet
Finally, we must explicitly link this public route table to our public subnet.
```bash
aws ec2 associate-route-table --subnet-id <PUBLIC_SUBNET_ID> --route-table-id <PUBLIC_ROUTE_TABLE_ID>
```
**Command Breakdown:**
- `associate-route-table`: Links a subnet to a route table.
- `--subnet-id`: The public subnet we created earlier.
- `--route-table-id`: The public route table containing the internet route.

---
🎉 **Congratulations!** You have successfully built a bifurcated network architecture entirely from the command line.

[⬅️ Back to Main README](./README.md)
