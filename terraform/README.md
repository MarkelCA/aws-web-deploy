# terraform
This folder contains the terraform files to provision the infrastructure for the web server. It creates an EC2 instance, with a DNS and propper security policies to enable HTTP,HTTPS and SSH protocols.

## AWS CLI configuration
To run it ensure you have the aws cli installed and configured:
```sh
aws configure
```

## Infrastructure provisioning
Then, to deploy the infrastructure run:
```sh
cd terraform
terraform init
terraform apply
```
It'll print the commands to store your SSH private key and to ssh into the machine. Run them on your terminal so you can configure the web server.

## DNS configuration
Now that the DNS is deployed on AWS, you have to add those name servers in your DNS hosting platform so that your domain uses the Route53 name servers to redirect requests to your machine. This is an example using [Squarespace Domains](https://domains.squarespace.com/):

![image](https://github.com/user-attachments/assets/72c3efe7-d158-4882-b06d-c125c9453678)


---

If you finished these steps now you can go to the [ansible](https://github.com/MarkelCA/aws-web-deploy/tree/master/ansible) folder to configure your web server.
