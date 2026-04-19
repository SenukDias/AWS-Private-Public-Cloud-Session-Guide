# 💻 GUI Method: AWS Management Console

This guide walks you through deploying the bifurcated VPC architecture step-by-step using the AWS Management Console.

---

## 1. Create the VPC

1. Log into your AWS account and navigate to the **VPC Dashboard**.
2. Click the **Create VPC** button.
3. Select the **VPC only** option (this allows us to configure everything manually for learning purposes).
4. **Name tag**: `my-bifurcated-vpc`
5. **IPv4 CIDR block**: `10.0.0.0/16`
6. Leave the rest as default and click **Create VPC**.

## 2. Create Subnets

Next, we will slice our VPC CIDR block into two smaller networks (subnets).

1. On the left sidebar, go to **Subnets** > **Create subnet**.
2. **VPC ID**: Select the VPC you just created (`my-bifurcated-vpc`).
3. **Configure Public Subnet**:
   - **Name**: `public-subnet-1`
   - **Availability Zone**: Choose one (e.g., `us-east-1a`)
   - **IPv4 CIDR block**: `10.0.1.0/24`
4. In the same window, click **Add new subnet** to configure the private subnet:
   - **Name**: `private-subnet-1`
   - **Availability Zone**: Choose the same zone (e.g., `us-east-1a`)
   - **IPv4 CIDR block**: `10.0.2.0/24`
5. Click **Create subnet**.

## 3. Create and Attach Internet Gateway (IGW)

The public subnet needs a way to route traffic to the internet.

1. Go to **Internet Gateways** > **Create internet gateway**.
2. **Name tag**: `my-igw`.
3. Click **Create internet gateway**.
4. The IGW will be created in a `Detached` state. Select it, click **Actions** > **Attach to VPC**.
5. Select `my-bifurcated-vpc` and click **Attach internet gateway**.

## 4. Configure Route Tables

By default, your VPC comes with a "main" route table. This table only routes traffic locally within the VPC. We will leave this as our **Private Route Table**.

1. **Create the Public Route Table**:
   - Go to **Route Tables** > **Create route table**.
   - **Name**: `public-route-table`.
   - **VPC**: `my-bifurcated-vpc`.
   - Click **Create route table**.
2. **Add an Internet Route**:
   - Select `public-route-table` from the list.
   - Go to the **Routes** tab, and click **Edit routes**.
   - Click **Add route**.
   - **Destination**: `0.0.0.0/0` (This means all external traffic).
   - **Target**: Select `Internet Gateway`, then choose `my-igw`.
   - Save changes.
3. **Associate with Public Subnet**:
   - Go to the **Subnet associations** tab of `public-route-table`.
   - Click **Edit subnet associations**.
   - Select `public-subnet-1`, and save.
   *(Note: `private-subnet-1` remains implicitly associated with the main/private route table, which has no internet route).*

## 5. Deploy EC2 Instances (Nodes)

Now we will test our networking by deploying two servers.

### Deploy the Public EC2 Web Node (Jump Node)
1. Go to the **EC2 Dashboard** > **Launch Instance**.
2. **Name**: `public-web-node`.
3. **AMI**: Amazon Linux 2023.
4. **Instance Type**: `t2.micro` (Free tier eligible).
5. **Key pair**: Create a new key pair (e.g., `my-aws-key`) and download the `.pem` file.
6. **Network settings** (Click Edit):
   - **VPC**: `my-bifurcated-vpc`.
   - **Subnet**: `public-subnet-1`.
   - **Auto-assign public IP**: **Enable**.
   - **Security Group**: Create new. Allow SSH (Port 22) and HTTP (Port 80) from Anywhere (0.0.0.0/0).
7. Click **Launch instance**.

### Deploy the Private EC2 Database Node
1. Click **Launch Instance** again.
2. **Name**: `private-db-node`.
3. **AMI**: Amazon Linux 2023.
4. **Instance Type**: `t2.micro`.
5. **Key pair**: Select the **same** key pair you created previously.
6. **Network settings** (Click Edit):
   - **VPC**: `my-bifurcated-vpc`.
   - **Subnet**: `private-subnet-1`.
   - **Auto-assign public IP**: **Disable** (Crucial for isolation).
   - **Security Group**: Create new. Allow SSH (Port 22) but restrict the source to the `public-web-node`'s security group or its private IP.
7. Click **Launch instance**.

## 6. Verification

Now, verify the network isolation:

1. **Attempt Direct Access to Private Node**:
   Find the **Private IP address** of your `private-db-node`. Try to SSH into it from your local computer:
   ```bash
   ssh -i "my-aws-key.pem" ec2-user@<PRIVATE_IP>
   ```
   *Result*: It will time out. The node is secure.

2. **Access via Jump Node**:
   SSH into your `public-web-node` using its **Public IP**:
   ```bash
   ssh -i "my-aws-key.pem" ec2-user@<PUBLIC_IP>
   ```
   Copy your SSH key to this node (or use SSH Agent Forwarding). Then, from inside the public node, run:
   ```bash
   ssh -i "my-aws-key.pem" ec2-user@<PRIVATE_IP>
   ```
   *Result*: Success! You have connected to the private subnet through the public jump node.

---
[⬅️ Back to Main README](./README.md)
