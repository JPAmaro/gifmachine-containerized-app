gifmachine-containerized-app
============================

Introduction:
-------------

This README provides a detailed guide on deploying the gifmachine application on AWS, utilizing technologies such as Amazon RDS, ECS, and Terraform, complemented by Ansible for configuration management.

Instructions to Run the Code:
-----------------------------

Prerequisites:
- AWS CLI installed and configured with appropriate access rights.
- Terraform installed.
- Ansible installed.
- Docker installed.

## Steps:

1. Terraform setup:

- `cd terraform`
- `terraform init`

2. Create AWS resources:

- `terraform plan -out=aws.tfplan`
- `terraform apply aws.tfplan`

### **Notes:**

```
AWS access credentials must be supplied at run time or, if created beforehand, Terraform can get the values from environment variables, that must be exported like this:
export TF_VAR_aws_access_key=your_access_key
export TF_VAR_aws_secret_key=your_secret_key

The scripts were tested with my AWS account with a user that has full admin policy.

This will provision the required resources on AWS, including RDS for Postgres, EC2 and ECS for application deployment.

Teardown AWS resources:
terraform destroy
```


3. Ansible setup:

- Navigate back to the root directory: `ansible-playbook ansible/deploy.yml`

4. Validation:

- Once the playbook finishes, you can validate the service by accessing the provided application URL.

### **Notes:**

```
This playbook will handle tasks such as building and pushing the Docker image to Amazon ECR and ensuring the ECS service is updated to use the latest image.
````


Solution Description:
---------------------

This solution utilizes Terraform to provision resources on AWS and Ansible for configuration, deployment and verifying that the application is up and running as expected.
The application in question is containerized and then orchestrated via Amazon ECS with EC2 as the launch type.

AWS RDS:
- Choice: RDS was selected as the database service for its managed services capabilities.
- Reasoning: It abstracts away administrative tasks such as backups, patching, and scaling, making it a great fit for production-ready applications.

Amazon ECS and EC2:
- Choice: Amazon Elastic Container Service was used to deploy the containerized application.
- Reasoning: ECS allows for efficient deployment, scaling, and management of Docker containers. I chose to use EC2 with ECS because it provides more granular control over the instances compared to Fargate. It allows for a more customizable and potentially cost-effective solution, depending on the workload.

AWS Systems Manager:
- Reasoning: AWS SSM (Systems Manager) Parameter Store allows for secure storage of configuration data and secrets. This ensures sensitive data like database credentials are kept safe and can be easily managed and rotated.

Terraform:
- Choice: Infrastructure as Code tool to provision AWS resources.
- Reasoning: Terraform provides a declarative approach to defining infrastructure, making it easy to version, replicate, and share.

Ansible:
- Choice: Configuration management and automated deployment.
- Reasoning: Ansible offers an imperative approach, providing a sequence of steps to achieve the desired state, which complements Terraform's declarative nature. It aids in tasks like Docker image deployment to ECR and updating the ECS service.

Paid services:
- AWS RDS
- Amazon EC2

Feedback on the Exercise:
- This exercise provided a comprehensive overview of deploying a real-world application on AWS. It touched on various aspects of AWS services, containerization, infrastructure as code, and configuration management.
- It was beneficial in highlighting the intricacies of deploying applications on AWS, focusing on best practices and security. It provided a platform for practical implementation, rather than just theoretical understanding.

Resources:
----------

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- https://docs.ansible.com/ansible/latest/collections/community/aws
- https://stackoverflow.com