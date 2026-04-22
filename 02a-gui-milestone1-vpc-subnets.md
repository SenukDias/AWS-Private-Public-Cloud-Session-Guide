# 💻 GUI Milestone 1: VPC and Subnets

In this first milestone, we will manually construct the core network boundary (VPC) and slice it into Public and Private Subnets using the AWS Management Console.

*(Prerequisite: Make sure you have completed [01 - Introduction & Setup](./01-introduction.md))*

---

## 1. Create the VPC

1. Log into your AWS account and navigate to the [**VPC Dashboard**](https://console.aws.amazon.com/vpc/).
2. Click the **Create VPC** button.
3. Select the **VPC only** option (this allows us to configure everything manually for learning purposes).
4. **Name tag**: `my-bifurcated-vpc`
5. **IPv4 CIDR block**: `10.0.0.0/16`
6. Leave the rest as default and click **Create VPC**.

## 2. Create Subnets

Next, we will slice our VPC CIDR block into two smaller networks (subnets).

1. On the left sidebar, go to [**Subnets**](https://console.aws.amazon.com/vpc/home#subnets:) > **Create subnet**.
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

---

### 🎉 Milestone 1 Complete!
You have successfully created your VPC and Subnets. Next, we need to configure how traffic flows in and out of them.

[![Next: Milestone 2 - Routing](https://img.shields.io/badge/Next_Task-Milestone_2_Routing-FF9900?style=for-the-badge)](./02b-gui-milestone2-routing.md)
