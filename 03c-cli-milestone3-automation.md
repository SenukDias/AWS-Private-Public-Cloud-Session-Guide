# 🚀 CLI Milestone 3: Script Automation

In this final milestone, we will use a Bash script (`deploy-vpc.sh`) to fully automate everything you just did in Milestones 1 and 2 in a single click!

*(Prerequisite: Make sure you have completed [CLI Milestone 2](./03b-cli-milestone2-routing.md))*

---

## 1. Review the Automation Script

We have provided a complete automation script in this repository. 

1. Open `deploy-vpc.sh` in your text editor.
2. Read through the script to understand how it uses the exact same commands you ran manually.
3. Notice how it dynamically sets variables and captures output to chain commands together!

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Review Script](./assets/recordings/review-script.gif)`)*

## 2. Execute the Script

Before running the script, make sure it has execution permissions.

```bash
chmod +x deploy-vpc.sh
```

Now, execute the script to build your bifurcated VPC instantly:

```bash
./deploy-vpc.sh
```

*The script will automatically measure latency to find the best region, create the VPC, subnets, internet gateway, route tables, and associate everything!*

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Execute Script](./assets/recordings/execute-script.gif)`)*

## 3. Verify Your Deployment

Once the script finishes, you can use the AWS CLI to verify your deployment. For example, to list your subnets in your new VPC:

```bash
aws ec2 describe-subnets --filters "Name=vpc-id,Values=<YOUR_NEW_VPC_ID>" --query "Subnets[*].{ID:SubnetId,CIDR:CidrBlock,Zone:AvailabilityZone}" --output table
```

> 🎥 **Screen Recording / Visuals**: *(Insert your screen recording or GIF here for this step: `![Verify Deployment](./assets/recordings/verify-deployment.gif)`)*

---

---

### 🎉 Lab Completed!
Congratulations, you have successfully automated a secure, bifurcated network architecture using the AWS CLI.

[![Return to Main Menu](https://img.shields.io/badge/Finish-Return_to_Main_Menu-232F3E?style=for-the-badge&logo=github)](./README.md)
