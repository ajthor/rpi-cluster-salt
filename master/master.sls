# This state file makes sure the Master is configured properly and has all of
# the necessary files for the system.

{% set ip_address = grains['ip4_interfaces']['wlan0'] %}
{% set master_host = "rpiomega-master.local" %}

# Make sure GitPython is installed.
pip-GitPython:
  pip.installed:
    - name: GitPython
    - require:
      - pkg: python-pip

# Initialize the swarm.
docker-swarm-init:
  cmd.run:
    - name: 'docker swarm init --advertise-addr '

docker-swarm-drain:
  cmd.run:
    - name: 'docker node update --availability drain {{ grains['id'] }}'

# Start the Consul server.
# consul-server:
#   dockerng.running:
#     - image: consul
#     - detach: True
#     - network_mode: host
#     - environment:
#       - CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}
#     - cmd: agent -server -bind={{ ip_address }} -retry-join={{ master_host }} -bootstrap-expect=3
#     - restart_policy: on-failure:5

# docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul agent -bind=<external ip> -retry-join=<root agent ip>
