![AWS Private/Public Cloud Session](./images/aws-session-banner.png)

[![AWS Architecture](https://img.shields.io/badge/AWS-Architecture-FF9900?style=flat-square&logo=amazonwebservices&logoColor=white)](#)&ensp;
[![Cloud Networking](https://img.shields.io/badge/Cloud-Networking-232F3E?style=flat-square&logo=amazonwebservices&logoColor=white)](#)&ensp;

🎯 [Overview](#-high-level-overview) &ensp; 🧪 [Lab Instructions](#-lab-instructions)

> **✨ Learn to master AWS networking by building a secure, bifurcated Virtual Private Cloud.**

This guide walks you through deploying an AWS VPC architecture from scratch. You will learn the crucial difference between Public and Private subnets, how to manage routing for secure backend resources, and how to verify your network isolation.

Think of this as your foundational step toward building secure, production-ready cloud environments.

## 🏗️ High-Level Overview

```mermaid
graph TD
    User((👨‍💻 User))
    
    subgraph "AWS Cloud Region"
        IGW[🌐 Internet Gateway]
        
        subgraph "VPC (10.0.0.0/16)"
            direction TB
            
            subgraph "Public Subnet (10.0.1.0/24)"
                Web[💻 Public Web Node<br>Jump Host]
                RT_Pub[🗺️ Public Route Table<br>0.0.0.0/0 ➡️ IGW]
            end
            
            subgraph "Private Subnet (10.0.2.0/24)"
                DB[🗄️ Private DB Node]
                RT_Priv[🗺️ Main Route Table<br>Local Routing Only]
            end
        end
    end

    User -->|Internet Traffic| IGW
    IGW <--> RT_Pub
    RT_Pub -.-> Web
    
    Web ===>|SSH via Jump Node| DB
    RT_Priv -.-> DB

    classDef pubSubnet fill:#e6f3ff,stroke:#0077b6,stroke-width:2px,color:#03045e
    classDef privSubnet fill:#fde2e4,stroke:#c1121f,stroke-width:2px,color:#780000
    classDef vpcBorder fill:none,stroke:#ff9900,stroke-width:3px,stroke-dasharray: 5 5
    classDef awsNode fill:#ff9900,stroke:#232f3e,stroke-width:2px,color:#fff
    
    class "Public Subnet (10.0.1.0/24)" pubSubnet
    class "Private Subnet (10.0.2.0/24)" privSubnet
    class "VPC (10.0.0.0/16)" vpcBorder
    class IGW,Web,DB awsNode
```

A bifurcated network architecture separates infrastructure into **Public** and **Private** subnets to enhance security. 

- <img src="./images/aws-vpc-icon.png" width="20" /> **Public Subnet**: Contains resources that require direct access to the internet, such as web servers, NAT gateways, or load balancers. These subnets have a route to an Internet Gateway (IGW).
- <img src="./images/aws-vpc-icon.png" width="20" /> **Private Subnet**: Contains backend resources that should not be directly accessible from the internet, such as databases or application servers. These subnets do not have a route to an IGW. They rely on Bastion Hosts (Jump Nodes) in the public subnet for inbound SSH access.

## 🗺️ Learning Path & Milestones

The following flowchart outlines the exact milestones you will complete during this workshop, depending on the learning path you choose.

```mermaid
graph TD
    Start([🏁 Start Workshop]) --> Choose{Choose Your Path}
    
    Choose -->|Beginner| GUI[💻 GUI Method<br>AWS Management Console]
    Choose -->|Intermediate| CLI[🚀 CLI Method<br>Terminal & Automation]
    
    %% GUI Milestones
    GUI --> G1[Milestone 1:<br>Create VPC & Subnets]
    G1 --> G2[Milestone 2:<br>Configure Routing & IGW]
    G2 --> G3[Milestone 3:<br>Deploy EC2 Nodes]
    G3 --> Verify1[Milestone 4:<br>Verify Network Isolation]
    
    %% CLI Milestones
    CLI --> C1[Milestone 1:<br>Install & Configure AWS CLI]
    C1 --> C2A[Milestone 2A:<br>Run Automation Script]
    C1 --> C2B[Milestone 2B:<br>Execute Manual Commands]
    C2A --> Verify2[Milestone 3:<br>Verify Network Isolation]
    C2B --> Verify2
    
    Verify1 --> Finish([🎉 Workshop Completed!])
    Verify2 --> Finish
    
    classDef default fill:#232F3E,stroke:#FF9900,stroke-width:2px,color:#fff;
    classDef highlight fill:#FF9900,stroke:#232F3E,stroke-width:2px,color:#232F3E;
    class Start,Choose,Finish highlight;
```

## 🚀 Start the Lab

[![Start Lab](https://img.shields.io/badge/Start_Lab-01_Introduction-FF9900?style=for-the-badge&logo=amazonwebservices&logoColor=white)](./01-introduction.md)

### 🛤️ Choose Your Path

After completing the introduction and setup, choose your preferred method to deploy the infrastructure:

[![GUI Method](https://img.shields.io/badge/Start_Option_A-GUI_Method-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white)](./02a-gui-milestone1-vpc-subnets.md)
[![CLI Method](https://img.shields.io/badge/Start_Option_B-CLI_Method-232F3E?style=for-the-badge&logo=gnu-bash&logoColor=white)](./03a-cli-milestone1-vpc-subnets.md)

*(Note: Both paths achieve the same final architecture. The CLI path includes a ready-to-run automation script: `deploy-vpc.sh`)*

---

## 🤝 Connect With Me
- 💼 **LinkedIn**: [linkedin.com/in/senukdias](https://www.linkedin.com/in/senukdias)
- 📱 **WhatsApp Channel**: [Join Here](https://whatsapp.com/channel/0029Van2p0gC6ZvfT0TjC10Y)
- 📸 **Instagram**: [@senukdias](https://www.instagram.com/senukdias)
- 👥 **Facebook**: [facebook.com/senukdias](https://www.facebook.com/senukdias)

## License
This project is licensed under the terms of the MIT open source license.
