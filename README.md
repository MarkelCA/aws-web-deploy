# terraform-aws-ecs
Batteries included template to deploy web servers in AWS. Leverages Terraform and Ansible to provision and configure the infrastructure. Deploys an Nginx web server in EC2, also configuring the DNS server with Route53 and SSH key access.

## Dependencies
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Build
The build process is divided between the provision step and the configuration step, described in the `terraform` and `ansible` folders respectively. Go to these folders and follow the instructions.
- [terraform](https://github.com/MarkelCA/web-deploy-scaffold/tree/master/terraform)
- [ansible](https://github.com/MarkelCA/web-deploy-scaffold/tree/master/ansible)

