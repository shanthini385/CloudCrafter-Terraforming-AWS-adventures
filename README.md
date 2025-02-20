Terraform & AWS Infrastructure Project - Step-by-Step Guide
------------------------------------------------------------

Overview:
---------
This project uses Terraform to provision a basic AWS infrastructure.
It creates a VPC, subnet, Internet Gateway, Route Table, Security Group,
and an EC2 instance. Additionally, it sets up a DNS record in Route 53
to map a friendly URL to the EC2 instance's public IP. This guide
documents all steps from setting up credentials to deploying and
verifying your infrastructure.

Prerequisites:
--------------
1. AWS Account
   - Ensure you have an active AWS account.
2. AWS CLI Installed & Configured
   - Install the AWS CLI.
   - Run: aws configure
   - Provide your:
     - AWS Access Key ID
     - AWS Secret Access Key
     - Default Region (e.g., us-west-2)
     - Default Output Format (e.g., json)
   - Verify with: aws sts get-caller-identity
3. Terraform Installed
   - Download Terraform from https://terraform.io/downloads
   - Verify with: terraform -v
     ![image](https://github.com/user-attachments/assets/5ddb44a5-ab24-46b9-99ff-43e505f53346)

4. IAM User with Sufficient Permissions
   - Use an IAM user with AdministratorAccess (or proper permissions)
   - Create an IAM user for Terraform and download its access keys if needed.
5. (Optional) AWS Key Pair for EC2
   - Create a key pair in the EC2 console (e.g., "my-key-pair")
   - Download the PEM file for SSH access.

Project Setup:
--------------
1. Create Project Directory
   - mkdir my_aws_project
   - cd my_aws_project

2. Create main.tf File
   - Use your favorite text editor to create and edit main.tf

Deployment:
-----------
1. Initialize Terraform:
   Command: terraform init

2. Review the Execution Plan:
   Command: terraform plan

3. Apply the Configuration:
   Command: terraform apply
   - When prompted, type "yes" to confirm.
   
4. Verify in AWS Console:
   - Check EC2 for your instance.
   - Verify VPC, subnet, and security group under the respective sections.
   - Check Route 53 for your DNS record.
   - In your browser, visit http://www.example.com (or the domain you configured).

Cleanup:
--------
To remove all resources created by Terraform:
   Command: terraform destroy
   - Confirm by typing "yes" when prompted.

Additional Notes:
-----------------
- The AWS Access Key and Secret used for 'aws configure' are stored in ~/.aws/credentials.
- Make sure your key pair (my-key-pair) exists in the region you are deploying.
- If you are using a custom domain, update your registrar's name servers to point to Route 53.
- Adjust CIDR blocks, instance types, and AMI IDs as needed for your environment.
- For production environments, use more secure IAM policies and limit access as needed.

=====================================================================
End of Guide
=====================================================================
