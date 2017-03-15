# This file initializes the swarm and configures the first manager. 

{% set ip_address = grains['ip4_interfaces']['wlan0'] %}

- include:
  - docker.mine

# Initialize the swarm.
docker-swarm-init:
  cmd.run:
    - name: 'docker swarm init --advertise-addr {{ ip_address }}'
