# This file configures the managers and joins them to the swarm.

{% set join_token = salt['mine.get']('*', 'manager_join_token').items()[0][1] %}
{% set join_ip = salt['mine.get']('*', 'manager_ip').items()[0][1][0] %}

include:
  - swarm.mine

swarm-join-manager:
  cmd.run:
    - name: 'docker swarm join --token {{ join_token }} {{ join_ip }}:2377'


# docker-swarm-drain:
#   cmd.run:
#     - name: 'docker node update --availability drain {{ grains['id'] }}'

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
