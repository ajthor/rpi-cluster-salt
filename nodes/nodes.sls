

{% set ip_address = grains['ip4_interfaces']['wlan0'] %}
{% set master_host = "rpiomega-master.local" %}
{% set join_token = salt['mine.get']('*', 'worker_token').items()[0][1] %}
{% set join_ip = salt['mine.get']('*', 'manager_ip').items()[0][1][0] %}

# Join the Docker swarm.
docker-swarm-join:
  cmd.run:
    - name: 'docker swarm join --token {{ join_token }} {{ master_host }}:2377'
    - require:
      - pkg: docker-engine

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
