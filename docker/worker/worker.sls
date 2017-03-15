# This file configures the workers and joins them to the swarm.

{% set join_token = salt['mine.get']('*', 'worker_token').items()[0][1] %}
{% set join_ip = salt['mine.get']('*', 'manager_ip').items()[0][1][0] %}

# Join the Docker swarm.
docker-swarm-join-worker:
  cmd.run:
    - name: 'docker swarm join --token {{ join_token }} {{ join_ip }}:2377'

# Start the Consul agent.
# consul-agent:
#   dockerng.running:
#     - image: consul
#     - detach: True
#     - network_mode: host
#     - environment:
#       - CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}
#     - cmd: agent -bind={{ ip_address }} -retry-join={{ master_host }}
#     - restart_policy: on-failure:5

# docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul agent -bind=<external ip> -retry-join=<root agent ip>
