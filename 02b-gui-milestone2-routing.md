# 💻 GUI Milestone 2: Routing and Internet Gateway

In this milestone, we will attach an Internet Gateway (IGW) to our VPC and configure the Route Tables to direct traffic appropriately for our public and private subnets.

*(Prerequisite: Make sure you have completed [GUI Milestone 1](./02a-gui-milestone1-vpc-subnets.md))*

---

## 1. Create and Attach Internet Gateway (IGW)

The public subnet needs a way to route traffic to the internet.

1. Go to [**Internet Gateways**](https://console.aws.amazon.com/vpc/home#igws:) > **Create internet gateway**.
2. **Name tag**: `my-igw`.
3. Click **Create internet gateway**.
4. The IGW will be created in a `Detached` state. Select it, click **Actions** > **Attach to VPC**.
5. Select `my-bifurcated-vpc` and click **Attach internet gateway**.

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Create IGW](./assets/recordings/create-igw.gif)`)*

## 2. Configure Route Tables

By default, your VPC comes with a "main" route table. This table only routes traffic locally within the VPC. We will leave this as our **Private Route Table**.

1. **Create the Public Route Table**:
   - Go to [**Route Tables**](https://console.aws.amazon.com/vpc/home#RouteTables:) > **Create route table**.
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

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Configure Routes](./assets/recordings/configure-routes.gif)`)*

---

---

### 🎉 Milestone 2 Complete!
Your networking foundation is complete! Now it's time to deploy resources and test it.

[![Next: Milestone 3 - EC2 & Verify](https://img.shields.io/badge/Next_Task-Milestone_3_EC2_&_Verify-FF9900?style=for-the-badge)](./02c-gui-milestone3-ec2-verify.md)
