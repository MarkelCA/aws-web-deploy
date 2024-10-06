# terraform-aws-ecs
Terraform template to deploy web servers in EC2. Comes with preconfigured SSH key access and DNS.

## Dependencies
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)

## Build
Firstly you will need to configure your AWS cli access:
```sh
aws configure
```
Then, to deploy the infrastructure run:
```sh
cd terraform
terraform init
terraform apply
```
It'll print the commands to store your SSH private key and to ssh into the machine. You can run them on your terminal.

## Configure
Now that you have your machine ready you will have to follow these steps to have your web server running:

- Change the Name Servers from your hosting platform to use the ones from Route53
- Access your machine via SSH and to perform the following steps:
    - Install your web server (e.g: nginx or apache)
    - Create a virtual host using the your domain as server name
    - Use Let's Encrypt's [certbot](https://certbot.eff.org/) to enable HTTPS connections
