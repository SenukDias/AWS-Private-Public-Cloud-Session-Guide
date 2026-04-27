# 🚀 CLI Milestone 2: Routing Configuration

In this milestone, we will use the AWS CLI to attach an Internet Gateway and map traffic using Route Tables to achieve our bifurcated setup.

*(Prerequisite: Make sure you have completed [CLI Milestone 1](./03a-cli-milestone1-vpc-subnets.md))*

---

## 1. Create and Attach the Internet Gateway

For resources in our public subnet to talk to the internet, our VPC needs an Internet Gateway (IGW).

### Create the IGW
```bash
aws ec2 create-internet-gateway
```
*(Copy the `"InternetGatewayId"` from the output).*

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Create IGW](./assets/recordings/create-igw.gif)`)*

### Tag and Attach the IGW
```bash
aws ec2 create-tags --resources <IGW_ID> --tags Key=Name,Value=my-igw
aws ec2 attach-internet-gateway --vpc-id <YOUR_VPC_ID> --internet-gateway-id <IGW_ID>
```

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Attach IGW](./assets/recordings/attach-igw.gif)`)*

---

## 2. Configure Route Tables

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

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Tag Private Route Table](./assets/recordings/tag-private-rt.gif)`)*

### Create the Public Route Table
Since the public subnet needs a different map, create a new route table.
```bash
aws ec2 create-route-table --vpc-id <YOUR_VPC_ID>
```
*(Copy the new `"RouteTableId"`).*
```bash
aws ec2 create-tags --resources <PUBLIC_ROUTE_TABLE_ID> --tags Key=Name,Value=public-route-table
```

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Tag Public Route Table](./assets/recordings/tag-public-rt.gif)`)*

### Add the Internet Route
Route all internet-bound traffic (`0.0.0.0/0`) to the Internet Gateway.
```bash
aws ec2 create-route --route-table-id <PUBLIC_ROUTE_TABLE_ID> --destination-cidr-block 0.0.0.0/0 --gateway-id <IGW_ID>
```

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Add Internet Route](./assets/recordings/add-route.gif)`)*

### Associate the Route Table with the Public Subnet
Link the public route table to our public subnet.
```bash
aws ec2 associate-route-table --subnet-id <PUBLIC_SUBNET_ID> --route-table-id <PUBLIC_ROUTE_TABLE_ID>
```

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Associate Route Table](./assets/recordings/associate-rt.gif)`)*

---

---

### 🎉 Milestone 2 Complete!
You have successfully built the routing logic for your architecture using the CLI. For the final milestone, we'll see how to automate all of these commands instantly!

[![Next: Milestone 3 - Automation](https://img.shields.io/badge/Next_Task-Milestone_3_Automation-FF9900?style=for-the-badge)](./03c-cli-milestone3-automation.md)
