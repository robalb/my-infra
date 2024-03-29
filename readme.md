## Infrastructure

Infrastructure-as-code lab, hosting my personal projects

control plane is a fork of https://github.com/vegasbrianc/prometheus/

## getting started

#### Install ansible

```bash
python3 -m pip install --user ansible
```

Configure the machine ip in `inventory.yml`. You must set it both in 
`virtualmachines` and `virtualmachines_INITIAL`, which is the initial way
ssh access is configured, that the first ansible playbook will change

#### Test that the INITIAL machines are accessible

```bash
ansible virtualmachines_INITIAL -m ping -i inventory.yml
```

#### Run the initial ssh setup

```bash
ansible-playbook -i inventory.yml initial_ssh_setup.yml
```

#### Run the rest of the setup

```bash
ansible-playbook -i inventory.yml software_setup.yml
```

#### Log in into your docker registry

(no reason to automate this, run this manually inside the vps)

```bash
docker login ghcr.io -u USERNAME
```

when prompted for a password, enter a classic ghcr token
with `read:packages` permissions. For more info:

https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry

### add a service

Once the control plane is up and running, you can add your projects to the vps.

TODO: write bash script to add to repository.
  usage:
     deploy.sh init (asks you questions, generates the compose-deploy folder)
     deploy.sh push 
     deploy.sh up
     deploy.sh down
     deploy.sh rollout
     deploy.sh deploy (push+rollout)

```
    labels:
      - 'traefik.enable=false'
      - 'traefik.http.routers.XXX.rule=Host(`subdomain.halb.it`)'
      - 'traefik.http.routers.XXX.entrypoints=websecure'
      - 'traefik.http.routers.XXX.tls=true'
      - 'traefik.http.routers.XXX.tls.certresolver=myresolver'

```

### Roadmap

document and create project structure:

    ansible       scripts for provisioning the vps
    control-plane shared ingress and observability stack
    deploy        build files for the deploy script you
     |            can add to your project repo
     L deploy.sh  the script
     L template/  the template it will download from github when you run deploy init

create deploy sh

#### provisioning

The ubuntu machine provisioning will be handled manually. I don't need fancy stuff

#### machine

write ansible files to configure the host ubuntu machine.

Initial step (INITIAL host,port=22,user=root): add ansible user, change ssh port

all other steps (host, port=xxxx,user=ansible)
- remove root login
- add "al" user, define keys, docker group
- install docker
- install database


#### References

https://docs.ansible.com/ansible/latest/getting_started/index.html




### Old roadmap

#### k8s files

define all the k8s infrastructure in a reproducible way:

- introspection services, grafana, loki, prometheus.
- analytics
- database web management (to find, something like phpmyadmin but serious)
- argocd
- secrets management
- secrets management integrated into argo (i put a link to a tutorial in telegram)


The idea is that all the personal projects will be managed via argo, secrets and databases will be configured manually from the respective admin panels.

The rest of the stuff on the cluster, such as the admin interfaces, argo, grafana etch will be defined in this repository.
Ideally, the charts and manifests in this repo should be managed via terraform.

#### machine

write ansible files to configure the host ubuntu machine.

- define ssh users and keys
- install mariadb
- install k3s

the idea is that mariadb (an other future databases) will be installed outside of k3s, but on the same machine, listening on the loopback interface. The access will be provided via a Service in the namespace external-services


#### provisioning

The ubuntu machine provisioning will be handled manually. I don't need fancy stuff

#### references

https://github.com/vitalk/ansible-secure-ssh

https://github.com/grafana/loki/issues/2361#issuecomment-1100472540

