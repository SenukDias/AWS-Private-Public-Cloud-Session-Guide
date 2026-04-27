# 🚀 CLI Milestone 1: Provision Core Network

In this milestone, we will use the AWS CLI to create the Virtual Private Cloud (VPC) and divide it into Public and Private subnets.

*(Prerequisite: Make sure you have completed [01 - Introduction & Setup](./01-introduction.md))*

> 📖 **Need help understanding a command?** 
> Check out the [**AWS CLI Command Manual**](./awscli-commands.md) for an in-depth breakdown of every command, keyword, and flag used in this tutorial!

---

## 1. Create the VPC

Create the Virtual Private Cloud (VPC), which acts as our isolated network boundary.

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```
*(Note: When you run this, AWS will output a JSON block containing your `"VpcId"`. You will need to copy this ID for the next steps!)*

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Create VPC](./assets/recordings/create-vpc.gif)`)*

### Tag the VPC
```bash
aws ec2 create-tags --resources <YOUR_VPC_ID> --tags Key=Name,Value=my-bifurcated-vpc
```

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Tag VPC](./assets/recordings/tag-vpc.gif)`)*

### Enable DNS Hostnames
```bash
aws ec2 modify-vpc-attribute --vpc-id <YOUR_VPC_ID> --enable-dns-hostnames "{\"Value\":true}"
```
*(Confused by these flags? See [aws ec2 modify-vpc-attribute in the manual](./awscli-commands.md#aws-ec2-modify-vpc-attribute)).*

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Enable DNS](./assets/recordings/enable-dns.gif)`)*

---

## 2. Create Subnets

Divide our VPC into two subnets: one Public and one Private.

### Create the Public Subnet
```bash
aws ec2 create-subnet --vpc-id <YOUR_VPC_ID> --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
```
*(Copy the `"SubnetId"` from the output for the public subnet).*

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Public Subnet](./assets/recordings/public-subnet.gif)`)*

### Tag and Configure the Public Subnet
```bash
aws ec2 create-tags --resources <PUBLIC_SUBNET_ID> --tags Key=Name,Value=public-subnet-1
aws ec2 modify-subnet-attribute --subnet-id <PUBLIC_SUBNET_ID> --map-public-ip-on-launch
```

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Tag Public Subnet](./assets/recordings/tag-public-subnet.gif)`)*

### Create the Private Subnet
```bash
aws ec2 create-subnet --vpc-id <YOUR_VPC_ID> --cidr-block 10.0.2.0/24 --availability-zone us-east-1a
aws ec2 create-tags --resources <PRIVATE_SUBNET_ID> --tags Key=Name,Value=private-subnet-1
```
*(Copy the `"SubnetId"` for the private subnet. Notice we do **not** run the `--map-public-ip-on-launch` command here).*

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Private Subnet](./assets/recordings/private-subnet.gif)`)*

---

---

### 🎉 Milestone 1 Complete!
Your VPC and subnets are successfully provisioned via CLI! Now let's connect them.

[![Next: Milestone 2 - Routing](https://img.shields.io/badge/Next_Task-Milestone_2_Routing-FF9900?style=for-the-badge)](./03b-cli-milestone2-routing.md)
