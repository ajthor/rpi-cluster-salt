# This file initializes the swarm and configures the first manager.

{% set ip_address = grains['ip4_interfaces']['wlan0'][0] %}

include:
  - .mine

# Initialize the swarm.
swarm-init:
  cmd.run:
    - name: 'docker swarm init --advertise-addr {{ ip_address }}'
