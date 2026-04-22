#!/bin/bash

# ==============================================================================
# AWS VPC Deployment Script
# Description: Automates the creation of a bifurcated VPC architecture with
#              1 Public Subnet, 1 Private Subnet, Route Tables, and an IGW.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# ==========================================
# Configuration Variables
# ==========================================
VPC_NAME="my-bifurcated-vpc-cli"
VPC_CIDR="10.0.0.0/16"
PUBLIC_SUBNET_CIDR="10.0.1.0/24"
PRIVATE_SUBNET_CIDR="10.0.2.0/24"
REGION=${AWS_DEFAULT_REGION:-"us-east-1"}

# ==========================================
# 1. Select Lowest Latency Region
# ==========================================
echo "Testing latency to common AWS regions to find the best deployment target..."
echo "(You can skip this in the future by setting AWS_DEFAULT_REGION)"

if [ -z "$AWS_DEFAULT_REGION" ]; then
    BEST_REGION="us-east-1"
    LOWEST_LATENCY=999

    for r in us-east-1 us-west-2 eu-west-1 ap-south-1 ap-southeast-1; do
        echo -n "Pinging $r... "
        LATENCY=$(curl -o /dev/null -s -w "%{time_total}\n" https://dynamodb.$r.amazonaws.com || echo "999")
        echo "${LATENCY}s"
        if awk "BEGIN {exit !($LATENCY < $LOWEST_LATENCY)}"; then
            LOWEST_LATENCY=$LATENCY
            BEST_REGION=$r
        fi
    done

    echo "✅ Selected $BEST_REGION as the deployment region based on lowest latency (${LOWEST_LATENCY}s)."
    REGION=$BEST_REGION
else
    echo "✅ Using pre-configured region: $REGION"
fi

AZ="${REGION}a"

echo "Starting deployment of VPC architecture in $REGION..."

# ==========================================
# 2. Create VPC
# ==========================================
echo "Creating VPC ($VPC_CIDR)..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query 'Vpc.VpcId' --output text)

# Tag the VPC
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $REGION

# Enable DNS hostnames (DNS resolution is enabled by default)
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames "{\"Value\":true}"
echo "✅ VPC created with ID: $VPC_ID"

# ==========================================
# 3. Create Public Subnet
# ==========================================
echo "Creating Public Subnet ($PUBLIC_SUBNET_CIDR)..."
PUB_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUBLIC_SUBNET_CIDR --availability-zone $AZ --region $REGION --query 'Subnet.SubnetId' --output text)

# Tag the Public Subnet
aws ec2 create-tags --resources $PUB_SUBNET_ID --tags Key=Name,Value="$VPC_NAME-public-subnet" --region $REGION

# Enable auto-assign public IP on launch
aws ec2 modify-subnet-attribute --subnet-id $PUB_SUBNET_ID --map-public-ip-on-launch
echo "✅ Public Subnet created with ID: $PUB_SUBNET_ID"

# ==========================================
# 4. Create Private Subnet
# ==========================================
echo "Creating Private Subnet ($PRIVATE_SUBNET_CIDR)..."
PRIV_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PRIVATE_SUBNET_CIDR --availability-zone $AZ --region $REGION --query 'Subnet.SubnetId' --output text)

# Tag the Private Subnet
aws ec2 create-tags --resources $PRIV_SUBNET_ID --tags Key=Name,Value="$VPC_NAME-private-subnet" --region $REGION
echo "✅ Private Subnet created with ID: $PRIV_SUBNET_ID"

# ==========================================
# 5. Create and Attach Internet Gateway
# ==========================================
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway --region $REGION --query 'InternetGateway.InternetGatewayId' --output text)

# Tag the IGW
aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value="$VPC_NAME-igw" --region $REGION

# Attach IGW to VPC
echo "Attaching IGW to VPC..."
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID --region $REGION
echo "✅ Internet Gateway created and attached. ID: $IGW_ID"

# ==========================================
# 6. Configure Route Tables
# ==========================================
echo "Configuring Route Tables..."

# The VPC comes with a default main route table. We tag it as the private route table.
MAIN_RT_ID=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID Name=association.main,Values=true --region $REGION --query 'RouteTables[0].RouteTableId' --output text)
aws ec2 create-tags --resources $MAIN_RT_ID --tags Key=Name,Value="$VPC_NAME-private-rt" --region $REGION

# Create a new Public Route Table
PUB_RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-tags --resources $PUB_RT_ID --tags Key=Name,Value="$VPC_NAME-public-rt" --region $REGION

# Add an outbound route to the Internet Gateway in the Public Route Table
aws ec2 create-route --route-table-id $PUB_RT_ID --destination-cidr-block "0.0.0.0/0" --gateway-id $IGW_ID --region $REGION > /dev/null

# Associate the Public Route Table with the Public Subnet
aws ec2 associate-route-table --subnet-id $PUB_SUBNET_ID --route-table-id $PUB_RT_ID --region $REGION > /dev/null
echo "✅ Route tables configured."

# ==========================================
# Summary
# ==========================================
echo ""
echo "=========================================================================="
echo "🎉 Deployment Complete!"
echo "=========================================================================="
echo "VPC ID:                     $VPC_ID"
echo "Public Subnet ID:           $PUB_SUBNET_ID"
echo "Private Subnet ID:          $PRIV_SUBNET_ID"
echo "Internet Gateway ID:        $IGW_ID"
echo "Public Route Table ID:      $PUB_RT_ID"
echo "Private Route Table (Main): $MAIN_RT_ID"
echo "=========================================================================="
