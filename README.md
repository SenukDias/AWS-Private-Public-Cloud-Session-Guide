# Define Your Private Public AWS Space

## High-Level Overview
A bifurcated network architecture separates infrastructure into **Public** and **Private** subnets to enhance security. 
- **Public Subnet**: Contains resources that require direct access to the internet, such as web servers, NAT gateways, or load balancers. These subnets have a route to an Internet Gateway (IGW).
- **Private Subnet**: Contains backend resources that should not be directly accessible from the internet, such as databases or application servers. These subnets do not have a route to an IGW. They rely on Bastion Hosts (Jump Nodes) in the public subnet for inbound SSH access, or NAT Gateways for outbound internet connectivity.

## GUI Deployment Guide: VPC & Networking

Follow these steps to deploy the VPC architecture via the AWS Management Console:

### 1. Create the VPC
1. Navigate to the **VPC Dashboard**.
2. Click **Create VPC**.
3. Select **VPC only**.
4. **Name tag**: `my-bifurcated-vpc`.
5. **IPv4 CIDR block**: `10.0.0.0/16`.
6. Click **Create VPC**.

### 2. Create Subnets
1. Go to **Subnets** > **Create subnet**.
2. Select your VPC: `my-bifurcated-vpc`.
3. **Configure Public Subnet**:
   - **Name**: `public-subnet-1`
   - **Availability Zone**: Choose one (e.g., `us-east-1a`)
   - **IPv4 CIDR block**: `10.0.1.0/24`
4. Click **Add new subnet** to configure the private subnet in the same window:
   - **Name**: `private-subnet-1`
   - **Availability Zone**: Choose the same zone (e.g., `us-east-1a`)
   - **IPv4 CIDR block**: `10.0.2.0/24`
5. Click **Create subnet**.

### 3. Create and Attach Internet Gateway (IGW)
1. Go to **Internet Gateways** > **Create internet gateway**.
2. **Name tag**: `my-igw`.
3. Click **Create internet gateway**.
4. Select the newly created IGW, click **Actions** > **Attach to VPC**, select `my-bifurcated-vpc`, and attach.

### 4. Configure Route Tables
By default, your VPC comes with a main route table. This will serve as your **Private Route Table** because it has no internet route.

1. **Create Public Route Table**:
   - Go to **Route Tables** > **Create route table**.
   - **Name**: `public-route-table`.
   - **VPC**: `my-bifurcated-vpc`.
   - Click **Create route table**.
2. **Add Internet Route**:
   - Select `public-route-table`, go to the **Routes** tab, and click **Edit routes**.
   - Click **Add route**: Destination `0.0.0.0/0`, Target `Internet Gateway` > select `my-igw`.
   - Save changes.
3. **Associate Public Subnet**:
   - Go to the **Subnet associations** tab of `public-route-table`.
   - Click **Edit subnet associations**, select `public-subnet-1`, and save.
*(The `private-subnet-1` remains implicitly associated with the main/private route table).*

---

## Deploying EC2 Nodes

### 1. Deploy Public EC2 Web Node (Jump Node)
1. Go to the **EC2 Dashboard** > **Launch Instance**.
2. **Name**: `public-web-node`.
3. **AMI**: Amazon Linux 2023.
4. **Instance Type**: `t2.micro`.
5. **Key pair**: Create a new key pair (e.g., `my-aws-key`) or select an existing one. Download the `.pem` file.
6. **Network settings**:
   - **VPC**: `my-bifurcated-vpc`.
   - **Subnet**: `public-subnet-1`.
   - **Auto-assign public IP**: **Enable**.
   - **Firewall (Security Groups)**: Create new. Allow SSH (Port 22) and HTTP (Port 80) from Anywhere (0.0.0.0/0).
7. Click **Launch instance**.

### 2. Deploy Private EC2 Database Node
1. Click **Launch Instance** again.
2. **Name**: `private-db-node`.
3. **AMI**: Amazon Linux 2023.
4. **Instance Type**: `t2.micro`.
5. **Key pair**: Select the **same** key pair used above.
6. **Network settings**:
   - **VPC**: `my-bifurcated-vpc`.
   - **Subnet**: `private-subnet-1`.
   - **Auto-assign public IP**: **Disable**.
   - **Firewall (Security Groups)**: Create new. Allow SSH (Port 22) from the `public-web-node`'s security group or its private IP.
7. Click **Launch instance**.

---

## Verification

Verify the network isolation and accessibility of your setup.

### 1. Attempt Direct Access to Private Node (Should Fail)
- Find the **Private IP address** of your `private-db-node` in the EC2 console.
- Open your local terminal.
- Attempt to ping or SSH directly into it:
  ```bash
  ssh -i "my-aws-key.pem" ec2-user@<PRIVATE_IP>
  ```
- **Result**: The connection will time out. The private subnet has no public IP and no direct route to the internet, confirming isolation.

### 2. Access via Jump Node (Should Succeed)
- SSH into your `public-web-node` using its **Public IP**:
  ```bash
  ssh -i "my-aws-key.pem" ec2-user@<PUBLIC_IP>
  ```
- To SSH into the private node from the jump node, you need your SSH key. You can securely copy it to the jump node, or use **SSH Agent Forwarding**.
  *(Alternatively, create a temporary file on the jump node and paste the contents of your `.pem` key, then `chmod 400 key.pem`).*
- From inside the `public-web-node`, SSH into the private node:
  ```bash
  ssh -i "my-aws-key.pem" ec2-user@<PRIVATE_IP>
  ```
- **Result**: You should successfully log in to the `private-db-node`. This proves that the private node is secure from the outside world but properly accessible internally via the public subnet jump node.
