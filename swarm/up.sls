# This file starts the swarm on the cluster. It is meant to be used from
# salt-call or salt-run with a command like:
# `sudo salt-run state.orchestrate swarm.up`

# Initialize the swarm on the Master. This provides a solid entry-point to the swarm that we can use to interact with everything. This way, you only ever need to SSH into the Master.

docker-swarm-init:
  salt.state:
    - sls: swarm.manager.init
    - tgt: 'rpiomega-master'

update-salt-mine:
  salt.function:
    - name: mine.update
    - tgt: '*'

{% for server in salt['saltutil.runner']('cache.grains', tgt='rpiomega-node-?', expr_form='glob') %}

# For the next two iterations, we also create managers. Just for redundancy.
{% if loop.index <= 2 %}

update-salt-mine-{{ server }}:
  salt.function:
    - name: mine.update
    - tgt: '*'
    - require:
      - salt: docker-swarm-add-manager-{{ server }}

docker-swarm-add-manager-{{ server }}:
  salt.state:
    - sls: swarm.manager.join
    - tgt: {{ server }}

# Every subsequent iteration creates a worker.
{% else %}

docker-swarm-add-worker-{{ server }}:
  salt.state:
    - sls: swarm.worker.join
    - tgt: {{ server }}

{% endif %}

{% endfor %}
