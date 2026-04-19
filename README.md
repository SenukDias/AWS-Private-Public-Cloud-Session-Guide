# AWS Private & Public Cloud Session Guide: Define Your Space

This repository provides a comprehensive guide and automation script for deploying a bifurcated AWS VPC architecture. This setup is a foundational pattern for secure cloud environments, separating public-facing resources from private, isolated backend systems.

## Architecture Overview

A **Bifurcated Network Architecture** divides a Virtual Private Cloud (VPC) into two distinct zones:

1.  **Public Subnet:**
    *   **Internet Access:** Has a direct route to an Internet Gateway (IGW).
    *   **Purpose:** Hosts "Front-end" or "Edge" services (e.g., Web Servers, Load Balancers, Jump Hosts).
    *   **Visibility:** Reachable from the public internet if security groups allow.

2.  **Private Subnet:**
    *   **Internet Access:** No direct route to the Internet Gateway. Outbound access usually requires a NAT Gateway (not included in this basic lab) or stays completely isolated.
    *   **Purpose:** Hosts "Back-end" services (e.g., Databases, Internal APIs, Legacy Systems).
    *   **Visibility:** Only reachable from within the VPC (e.g., from the Public Subnet).

---

## GUI Deployment Instructions (Step-by-Step)

### 1. Create the VPC
1.  Navigate to the **VPC Dashboard** in the AWS Console.
2.  Click **Create VPC**.
3.  Select **VPC only**.
4.  **Name tag:** `Session-VPC`
5.  **IPv4 CIDR block:** `10.0.0.0/16`
6.  Click **Create VPC**.

### 2. Create Subnets
1.  Go to **Subnets** > **Create subnet**.
2.  Select `Session-VPC`.
3.  **Public Subnet:**
    *   **Name:** `Public-Subnet`
    *   **Availability Zone:** Select any (e.g., `us-east-1a`).
    *   **IPv4 CIDR:** `10.0.1.0/24`.
4.  **Private Subnet:**
    *   **Name:** `Private-Subnet`
    *   **Availability Zone:** Same as above.
    *   **IPv4 CIDR:** `10.0.2.0/24`.
5.  Click **Create subnet**.

### 3. Setup Connectivity (IGW & Route Tables)
1.  **Internet Gateway:**
    *   Go to **Internet Gateways** > **Create internet gateway**. Name it `Session-IGW`.
    *   Select the new IGW > **Actions** > **Attach to VPC** > Select `Session-VPC`.
2.  **Public Route Table:**
    *   Go to **Route Tables** > **Create route table**. Name it `Public-RT`. Select `Session-VPC`.
    *   Select `Public-RT` > **Routes** > **Edit routes**.
    *   Add route: `0.0.0.0/0` -> Target: `Internet Gateway` (`Session-IGW`).
    *   Go to **Subnet associations** > **Edit subnet associations** > Select `Public-Subnet`.
3.  **Private Route Table:**
    *   Create `Private-RT`. Select `Session-VPC`.
    *   Go to **Subnet associations** > Select `Private-Subnet`. (Leave routes local-only).

---

## Deploying EC2 Nodes

### Public Web Node
1.  **Launch Instance:** Name it `Web-Node`.
2.  **AMI:** Amazon Linux 2023.
3.  **Network:** Select `Session-VPC` and `Public-Subnet`.
4.  **Auto-assign Public IP:** Enable.
5.  **Security Group:** Allow SSH (22) and HTTP (80) from `0.0.0.0/0`.

### Private Database Node
1.  **Launch Instance:** Name it `DB-Node`.
2.  **Network:** Select `Session-VPC` and `Private-Subnet`.
3.  **Auto-assign Public IP:** Disable.
4.  **Security Group:** Allow SSH (22) and Database ports (e.g., 3306) **ONLY** from the `Web-Node` Security Group ID.

---

## Verification

### 1. Test External Isolation
*   Attempt to ping or SSH into the **Public IP** of `Web-Node`. It should succeed.
*   Attempt to ping or SSH into the **Private IP** of `DB-Node` from your local machine. It should **fail** (it has no public IP or route).

### 2. Test Internal Connectivity (Jump Box Pattern)
1.  SSH into `Web-Node`.
2.  From `Web-Node`, attempt to ping or SSH into the **Private IP** of `DB-Node`.
3.  This should **succeed**, proving that the private node is reachable only from within the trusted network.
