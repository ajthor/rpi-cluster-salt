# This file starts the swarm on the cluster. It is meant to be used from
# salt-call or salt-run with a command like:
# `salt-run state.orchestrate docker.swarm`


{% for server, host in salt['mine.get']('*', 'hostnames', expr_form='grain') | dictsort() %}

update-salt-mine-{{ server }}:
  salt.function:
    - name: mine.update
    - tgt: '*'

# On the first iteration of the loop, we need to initialize the swarm.
{% if loop.first %}

docker-swarm-init-{{ server }}:
  salt.state:
    - sls: docker.manager.init
    - tgt: 'rpiomega-master'
    - require_in:
      - salt: update-salt-mine-{{ server }}

# For the next two iterations, we also create managers. Just for redundancy.
{% elif loop.index < 3 %}

docker-swarm-add-manager-{{ server }}:
  salt.state:
    - sls: docker.manager.manager
    - tgt: {{ server }}
    - require_in:
      - salt: update-salt-mine-{{ server }}

# Every subsequent iteration creates a worker.
{% else %}

docker-swarm-add-worker-{{ server }}:
  salt.state:
    - sls: docker.worker.worker
    - tgt: {{ server }}

{% endif %}

{% endfor %}
