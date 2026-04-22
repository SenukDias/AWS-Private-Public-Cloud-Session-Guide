# 🚀 CLI Method: AWS Command Line Interface

This guide walks you through deploying the bifurcated VPC architecture entirely using the AWS Command Line Interface (CLI). 

> 📖 **Need help understanding a command?** 
> Check out the [**AWS CLI Command Manual**](./awscli-commands.md) for an in-depth breakdown of every command, keyword, and flag used in this tutorial!

---

## 🛠️ Step 0: Account Setup & Connecting the CLI

Before interacting with AWS from your terminal, you need an AWS account, programmatic credentials, and the CLI tool installed.

### 1. Create an AWS Account
If you don't have one, go to [aws.amazon.com](https://aws.amazon.com/) and create a **Free Tier** account. Provide the necessary details and verify your identity.

### 2. Create an IAM User for CLI Access
For security reasons, **never** use your Root Account credentials in the CLI. We will create a dedicated programmatic user.
1. Log into the AWS Management Console and navigate to the **IAM Dashboard**.
2. Go to **Users** and click **Create user**.
3. **User name**: `cli-admin` (Skip console access, this is just for the terminal).
4. Under Permissions, select **Attach policies directly** and check `AdministratorAccess` (for this lab).
5. Click **Create user**.
6. Click on your new `cli-admin` user and navigate to the **Security credentials** tab.
7. Scroll down to **Access keys** and click **Create access key**.
8. Select **Command Line Interface (CLI)** as the use case.
9. **IMPORTANT**: Copy your **Access Key ID** and **Secret Access Key** or download the `.csv` file. You will not be able to see the secret key again!

### 3. Install the AWS CLI

**For Linux / macOS:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
*(For Windows, download and run the MSI installer from the [official AWS docs](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).)*

### 4. Configure AWS Credentials
Once installed, link the CLI to the IAM user you created in Step 2.
```bash
aws configure
```
*(See the [AWS CLI Manual](./awscli-commands.md#aws-configure) to learn what this interactive prompt expects).*

---

## 🌍 Step 1: Select the Lowest Latency Region

Before deploying resources, you should choose the AWS region with the lowest latency to your location. 

You can use a web tool like [awsspeedtest.com](https://awsspeedtest.com/) (or [cloudping.info](https://www.cloudping.info/)) or run a quick test directly from your CLI using `curl`:

```bash
# Test latency to a few common regions
for region in us-east-1 us-west-2 eu-west-1 ap-south-1 ap-southeast-1; do
  echo -n "$region: "
  curl -o /dev/null -s -w "%{time_total} seconds\n" https://dynamodb.$region.amazonaws.com
done
```

Once you identify the fastest region, configure it as your default for this session, or pass it to your deployment script.

```bash
# Set your region as an environment variable
export AWS_DEFAULT_REGION="<YOUR_CHOSEN_REGION>"
```

---

## 🏗️ Step 2: Create the VPC

Create the Virtual Private Cloud (VPC), which acts as our isolated network boundary.

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```
*(Note: When you run this, AWS will output a JSON block containing your `"VpcId"`. You will need to copy this ID for the next steps!)*

### Tag the VPC
```bash
aws ec2 create-tags --resources <YOUR_VPC_ID> --tags Key=Name,Value=my-bifurcated-vpc
```

### Enable DNS Hostnames
```bash
aws ec2 modify-vpc-attribute --vpc-id <YOUR_VPC_ID> --enable-dns-hostnames "{\"Value\":true}"
```
*(Confused by these flags? See [aws ec2 modify-vpc-attribute in the manual](./awscli-commands.md#aws-ec2-modify-vpc-attribute)).*

---

## 🌐 Step 3: Create Subnets

Divide our VPC into two subnets: one Public and one Private.

### Create the Public Subnet
```bash
aws ec2 create-subnet --vpc-id <YOUR_VPC_ID> --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
```
*(Copy the `"SubnetId"` from the output for the public subnet).*

### Tag and Configure the Public Subnet
```bash
aws ec2 create-tags --resources <PUBLIC_SUBNET_ID> --tags Key=Name,Value=public-subnet-1
aws ec2 modify-subnet-attribute --subnet-id <PUBLIC_SUBNET_ID> --map-public-ip-on-launch
```

### Create the Private Subnet
```bash
aws ec2 create-subnet --vpc-id <YOUR_VPC_ID> --cidr-block 10.0.2.0/24 --availability-zone us-east-1a
aws ec2 create-tags --resources <PRIVATE_SUBNET_ID> --tags Key=Name,Value=private-subnet-1
```
*(Copy the `"SubnetId"` for the private subnet. Notice we do **not** run the `--map-public-ip-on-launch` command here).*

---

## 🚪 Step 4: Create and Attach the Internet Gateway

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

---

## 🗺️ Step 5: Configure Route Tables

A route table acts as a map, telling network traffic where it is allowed to go.

### Tag the Private Route Table
Find the main route table ID generated with your VPC:
```bash
aws ec2 describe-route-tables --filters Name=vpc-id,Values=<YOUR_VPC_ID> Name=association.main,Values=true --query 'RouteTables[0].RouteTableId' --output text
```
*(Copy the output string).*
```bash
aws ec2 create-tags --resources <MAIN_ROUTE_TABLE_ID> --tags Key=Name,Value=private-route-table
```

### Create the Public Route Table
Since the public subnet needs a different map, create a new route table.
```bash
aws ec2 create-route-table --vpc-id <YOUR_VPC_ID>
```
*(Copy the new `"RouteTableId"`).*
```bash
aws ec2 create-tags --resources <PUBLIC_ROUTE_TABLE_ID> --tags Key=Name,Value=public-route-table
```

### Add the Internet Route
Route all internet-bound traffic (`0.0.0.0/0`) to the Internet Gateway.
```bash
aws ec2 create-route --route-table-id <PUBLIC_ROUTE_TABLE_ID> --destination-cidr-block 0.0.0.0/0 --gateway-id <IGW_ID>
```

### Associate the Route Table with the Public Subnet
Link the public route table to our public subnet.
```bash
aws ec2 associate-route-table --subnet-id <PUBLIC_SUBNET_ID> --route-table-id <PUBLIC_ROUTE_TABLE_ID>
```

---
🎉 **Congratulations!** You have successfully built a bifurcated network architecture entirely from the command line.

[⬅️ Back to Main README](./README.md)
