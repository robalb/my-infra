# shadow infra

shadow infra contains all the infrastructure configurations that are
not designed to be open sourced. This should not contain sensitive informations. As of now, it contains the deployment files for the ssh honeypot

## folder structure

These are the deployment files for the docker-compose production environment. For more informations read the my-infra repository

```
ansible-playbook -i vps, -e "ansible_port=6477" -u al ansible-deploy.yml
```

