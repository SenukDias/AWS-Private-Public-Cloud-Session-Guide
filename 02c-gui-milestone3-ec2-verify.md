# 💻 GUI Milestone 3: Deploy EC2 Nodes and Verify

In this final milestone, we will deploy two EC2 instances—one in the Public Subnet and one in the Private Subnet—and verify that our network isolation works exactly as designed.

*(Prerequisite: Make sure you have completed [GUI Milestone 2](./02b-gui-milestone2-routing.md))*

---

## 1. Deploy EC2 Instances (Nodes)

Now we will test our networking by deploying two servers.

### Deploy the Public EC2 Web Node (Jump Node)
1. Go to the [**EC2 Dashboard**](https://console.aws.amazon.com/ec2/) > **Launch Instance**.
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

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Deploy Public Node](./assets/recordings/deploy-public-node.gif)`)*

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

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Deploy Private Node](./assets/recordings/deploy-private-node.gif)`)*

## 2. Verification

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

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Verification](./assets/recordings/verification.gif)`)*

---

---

### 🎉 Lab Completed!
Congratulations, you have successfully built a secure, bifurcated network architecture.

[![Return to Main Menu](https://img.shields.io/badge/Finish-Return_to_Main_Menu-232F3E?style=for-the-badge&logo=github)](./README.md)
