# 🌟 01 - Introduction & Setup

Before we start building our bifurcated VPC architecture, we need to set up our AWS environment and determine the best region for deployment.

---

## 🌍 Step 1: Select the Lowest Latency Region

Before creating any resources, it's best practice to choose the AWS region closest to you or your users to minimize latency.

1. Open your web browser and go to [awsspeedtest.com](https://awsspeedtest.com/) (or [cloudping.info](https://www.cloudping.info/)).
2. Run the ping test to find the region with the lowest latency (measured in milliseconds).
3. Once you identify the best region (e.g., `us-east-1`, `ap-south-1`, etc.), take note of it.
   - **For GUI Users**: In the top right corner of the AWS Console, click the **Region** dropdown and select your chosen region.
   - **For CLI Users**: Set your region as an environment variable in your terminal: `export AWS_DEFAULT_REGION="<YOUR_CHOSEN_REGION>"`

> 🎥 **Screen Recording / Visuals**:

![Latency Test](./assets/recordings/1-Test-the-Latency.gif)

---

## 🛠️ Step 2: Create an AWS Account (Prerequisite)

Before you begin, you need an active AWS account.

1. Go to the [AWS Portal](https://aws.amazon.com/) and click **Create a Free Account**.
2. Follow the instructions to enter your email and choose a secure password.
3. Provide your contact and billing information. *(Note: A valid credit/debit card is required to verify your identity, but you will not be charged if you strictly follow Free Tier limits).*
4. Verify your phone number and select the **Basic Support - Free** plan.
5. Wait for the activation email. Once activated, log into the [AWS Management Console](https://console.aws.amazon.com/) to begin.

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![AWS Account](../assets/recordings/aws-account.gif)`)*

---

## 💻 Step 3 (Optional): CLI Prerequisites

*If you plan to use the AWS Management Console (GUI), you can skip this step and proceed directly to deployment.*

If you plan to use the command line, you need programmatic credentials and the CLI tool installed.

### 1. Create an IAM User for CLI Access

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

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![IAM User](../assets/recordings/iam-user.gif)`)*

### 2. Install the AWS CLI

**For Linux / macOS:**

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

*(For Windows, download and run the MSI installer from the [official AWS docs](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).)*

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Install CLI](../assets/recordings/install-cli.gif)`)*

### 3. Configure AWS Credentials

Once installed, link the CLI to the IAM user you created.

```bash
aws configure
```

*(Provide the Access Key, Secret Key, and your chosen Region).*

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Configure CLI](../assets/recordings/configure-cli.gif)`)*

---

## 🚀 Choose Your Deployment Path

Now that your setup is complete, you have two options to continue your training. Choose the method that best aligns with your learning goals.

### 💻 Option A: GUI Method (AWS Management Console)

Best for beginners who want a visual, step-by-step understanding of AWS networking concepts.

**Milestones you will complete:**

1. **Milestone 1:** Manually construct the VPC and slice it into Public and Private Subnets.
2. **Milestone 2:** Attach an Internet Gateway and map traffic using Route Tables.
3. **Milestone 3:** Deploy EC2 Nodes and test your network isolation and security rules.

[![Start GUI Method](https://img.shields.io/badge/Start_Option_A-GUI_Method-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white)](./02a-gui-milestone1-vpc-subnets.md)

---

### 🚀 Option B: CLI Method (Terminal & Automation)

Best for intermediate users focused on terminal commands and automation.

**Milestones you will complete:**

1. **Milestone 1:** Provision the core VPC network boundary using AWS CLI commands.
2. **Milestone 2:** Programmatically attach an Internet Gateway and configure routing tables.
3. **Milestone 3:** Execute a complete, one-click `deploy-vpc.sh` bash automation script.

[![Start CLI Method](https://img.shields.io/badge/Start_Option_B-CLI_Method-232F3E?style=for-the-badge&logo=gnu-bash&logoColor=white)](./03a-cli-milestone1-vpc-subnets.md)

---
[⬅️ Back to Main README](./README.md)
