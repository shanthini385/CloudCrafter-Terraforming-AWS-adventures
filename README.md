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

     ![image](https://github.com/user-attachments/assets/fe1be96c-f438-48dc-985a-ee925b47c733)

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

     ![image](https://github.com/user-attachments/assets/744f401b-216a-4d0e-abac-05685381247c)


4. IAM User with Sufficient Permissions
   - Use an IAM user with AdministratorAccess (or proper permissions)
   - Create an IAM user for Terraform and download its access keys if needed.
     
     <img width="957" alt="image" src="https://github.com/user-attachments/assets/5ec7c705-b9aa-471d-984f-fd7e53d7f9ea" />

5. (Optional) AWS Key Pair for EC2
   - Create a key pair in the EC2 console (e.g., "my-key-pair")
   - Download the PEM file for SSH access.
     
     <img width="957" alt="image" src="https://github.com/user-attachments/assets/bd717a46-f5fe-49e6-b94a-a87ef1597e22" />


Project Setup:
--------------
1. Create Project Directory
   - mkdir my_aws_project
   - cd my_aws_project

2. Create main.tf File
   - Use your favorite text editor to create and edit main.tf

     ![image](https://github.com/user-attachments/assets/7ea04d98-587a-469d-8449-bab3e93395ba)


Deployment:
-----------
1. Initialize Terraform:
   Command: terraform init

   ![image](https://github.com/user-attachments/assets/9142287f-0b69-4386-a3b6-9c74e449e5cb)


3. Review the Execution Plan:
   Command: terraform plan

   ![image](https://github.com/user-attachments/assets/41e255e9-66ba-47d0-b610-f475b0a6ef7e)


4. Apply the Configuration:
   Command: terraform apply
   - When prompted, type "yes" to confirm.

     <img width="953" alt="image" src="https://github.com/user-attachments/assets/17784820-edda-47c8-8d5c-69937c1d8b85" />

     ![image](https://github.com/user-attachments/assets/32eb5fc3-42a4-4e3b-b85d-bf7a189870b5)
   
5. Verify in AWS Console:
   - Check EC2 for your instance.
   - Verify VPC, subnet, and security group under the respective sections.
   - Check Route 53 for your DNS record.
   - In your browser, visit http://www.example.com (or the domain you configured).

     <img width="954" alt="image" src="https://github.com/user-attachments/assets/2ba56251-d41d-4857-8b10-0aeb68db27bb" />

     <img width="958" alt="image" src="https://github.com/user-attachments/assets/544f2710-c80d-43c1-828c-47c89cc8cfce" />



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
