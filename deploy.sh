#!/bin/bash

# 1. Let's provision the VMs for our Docker Swarm cluster.
multipass launch --name manager      --cpus 2 --mem 2G --disk 10G  --cloud-init ./cloud-init.yml
multipass launch --name app-worker   --cpus 2 --mem 4G --disk 10G  --cloud-init ./cloud-init.yml
multipass launch --name data-worker  --cpus 2 --mem 4G --disk 20G  --cloud-init ./cloud-init.yml

# Let's make sure the VMs have successfully booted up.
multipass start manager app-worker data-worker

# Let's add the VMs' IPs to our local /etc/hosts so we can use hostnames. 
# IMPORTANT NOTE: Remove these entries when you delete the Docker Swarm cluster.

export MANAGER_IP=$(multipass exec manager -- hostname -I | awk '{print $1}')
export APP_WORKER_IP=$(multipass exec app-worker -- hostname -I | awk '{print $1}')
export DATA_WORKER_IP=$(multipass exec data-worker -- hostname -I | awk '{print $1}')

source dotenv
echo -e "${MANAGER_IP}  manager ${SWARMPIT_HOST} ${TRAEFIK_HOST} ${PGADMIN_HOST} \n" >> /etc/hosts
echo -e "${APP_WORKER_IP}  app-worker  \n" >> /etc/hosts
echo -e "${DATA_WORKER_IP}  data-worker  \n" >> /etc/hosts

# 2. Let's initialize Docker Swarm on our VMs.

multipass exec manager -- docker swarm init --advertise-addr ${MANAGER_IP}:2377
export WORKER_JOIN_TOKEN=$(multipass exec manager -- docker swarm join-token worker --quiet)
multipass exec app-worker  -- docker swarm join --token ${WORKER_JOIN_TOKEN} ${MANAGER_IP}:2377
multipass exec data-worker -- docker swarm join --token ${WORKER_JOIN_TOKEN} ${MANAGER_IP}:2377

# 3. Let's deploy our applications to Docker Swarm.

# The manager node needs access to the installation files so let's mount
# the current directory into the manager node's /home/ubuntu/workspace directory.

multipass mount ./ manager:/home/ubuntu/workspace

# Let's create a Docker overlay network. All our Docker containers will communicate
# over this virtual network.

multipass exec manager -- docker network create --driver overlay --attachable internal
multipass exec manager -- docker network create --driver overlay --attachable public

# Let's copy the environment file to the default location.
multipass exec manager -- ln -s /home/ubuntu/workspace/.env /home/ubuntu/.env

# Let's deploy the admin services.
multipass exec manager -- dotenv docker stack deploy -c /home/ubuntu/workspace/admin.yml admin

# Let's deploy the database services.
multipass exec manager -- dotenv docker stack deploy -c /home/ubuntu/workspace/database.yml database

# Let's deploy Superset.
multipass exec manager -- dotenv docker stack deploy -c /home/ubuntu/workspace/super.yml super

# TODO: write to .bashrc instead of using dotenv
