#!/bin/bash

export MANAGER_IP=$(multipass exec manager -- hostname -I | awk '{print $1}')
export APP_WORKER_IP=$(multipass exec app-worker -- hostname -I | awk '{print $1}')
export DATA_WORKER_IP=$(multipass exec data-worker -- hostname -I | awk '{print $1}')

source dotenv
echo -e "${MANAGER_IP}  manager ${SWARMPIT_HOST} ${TRAEFIK_HOST} ${PGADMIN_HOST} \n" >> /etc/hosts
echo -e "${APP_WORKER_IP}  app-worker  \n" >> /etc/hosts
echo -e "${DATA_WORKER_IP}  data-worker  \n" >> /etc/hosts
