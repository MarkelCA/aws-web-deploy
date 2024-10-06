# ansible
This folder contains the ansible automation files to install the web server inside the machine. It installs nginx, creates a virtual host and installs a SSL certificate using Let's Encrypt's [certbot](https://certbot.eff.org/) to enable HTTPS.

## Web server configuration

To run it ensure the `ansible_ssh_private_key_file` in the `inventory.yml` file matches a valid ssh key for the instance. Then execute:

```sh
ansible-playbook -i inventory.yml playbook.yml
```

If no errors were thrown you finished configuring the web server, now you can visit your domain and it should be accessible.
