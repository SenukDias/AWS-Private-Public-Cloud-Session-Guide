#!/bin/bash

# AWS VPC Deployment Script
# Description: Automates the creation of a Public/Private VPC architecture.

# Variables
VPC_NAME="Session-VPC"
VPC_CIDR="10.0.0.0/16"
PUB_SUB_CIDR="10.0.1.0/24"
PRIV_SUB_CIDR="10.0.2.0/24"
REGION=$(aws configure get region)

echo "Starting deployment in region: $REGION"

# 1. Create VPC
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME
echo "VPC Created: $VPC_ID"

# 2. Create Public Subnet
echo "Creating Public Subnet..."
PUB_SUB_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUB_SUB_CIDR --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $PUB_SUB_ID --tags Key=Name,Value="Public-Subnet"
echo "Public Subnet Created: $PUB_SUB_ID"

# 3. Create Private Subnet
echo "Creating Private Subnet..."
PRIV_SUB_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PRIV_SUB_CIDR --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $PRIV_SUB_ID --tags Key=Name,Value="Private-Subnet"
echo "Private Subnet Created: $PRIV_SUB_ID"

# 4. Create Internet Gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value="Session-IGW"
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
echo "IGW Created and Attached: $IGW_ID"

# 5. Create Public Route Table
echo "Creating Public Route Table..."
PUB_RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-tags --resources $PUB_RT_ID --tags Key=Name,Value="Public-RT"
# Add route to Internet
aws ec2 create-route --route-table-id $PUB_RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
# Associate with Public Subnet
aws ec2 associate-route-table --subnet-id $PUB_SUB_ID --route-table-id $PUB_RT_ID
echo "Public Route Table Configured: $PUB_RT_ID"

# 6. Create Private Route Table
echo "Creating Private Route Table..."
PRIV_RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-tags --resources $PRIV_RT_ID --tags Key=Name,Value="Private-RT"
# Associate with Private Subnet
aws ec2 associate-route-table --subnet-id $PRIV_SUB_ID --route-table-id $PRIV_RT_ID
echo "Private Route Table Configured: $PRIV_RT_ID"

echo "------------------------------------------------"
echo "Deployment Complete!"
echo "VPC ID: $VPC_ID"
echo "Public Subnet: $PUB_SUB_ID"
echo "Private Subnet: $PRIV_SUB_ID"
echo "------------------------------------------------"
