# This file starts the swarm on the cluster. It is meant to be used from
# salt-call or salt-run with a command like:
# `sudo salt-run state.orchestrate swarm.up`

# Initialize the swarm on the Master. This provides a solid entry-point to the
# swarm that we can use to interact with everything. This way, you should only
# ever need to SSH into the Master.
swarm-start:
  salt.state:
    - sls: swarm.manager.init
    - tgt: 'rpiomega-master'
    - unless:
      - docker node inspect self

update-salt-mine:
  salt.function:
    - name: mine.update
    - tgt: 'rpiomega-master'

{% for server in salt['saltutil.runner']('cache.grains', tgt='rpiomega-node-?', expr_form='glob') %}

# For the next two iterations, we create managers. Just for redundancy.
{% if loop.index <= 2 %}

add-manager-{{ server }}:
  salt.state:
    - sls: swarm.manager.join
    - tgt: {{ server }}

update-salt-mine-{{ server }}:
  salt.function:
    - name: mine.update
    - tgt: {{ server }}
    - require:
      - salt: add-manager-{{ server }}

# Every subsequent iteration creates a worker.
{% else %}

add-worker-{{ server }}:
  salt.state:
    - sls: swarm.worker.join
    - tgt: {{ server }}

{% endif %}

{% endfor %}
