# This file starts the swarm on the cluster. It is meant to be used from
# salt-call or salt-run with a command like:
# `salt-run state.orchestrate docker.swarm`


{% for node in salt['saltutil.runner']('cache.grains', tgt='*', expr_form='nodegroup') %}

update-salt-mine-{{ node }}:
  salt.function:
    - name: mine.update
    - tgt: '*'
    - require:
      - salt: docker-swarm-add-manager

{% if loop.first %}

docker-swarm-init-{{ node }}:
  salt.state:
    - sls: docker.manager.init
    - tgt: {{ node }}
    - require_in:
      - salt: update-salt-mine-{{ node }}

{% elif loop.index < 3 %}

docker-swarm-add-manager-{{ node }}:
  salt.state:
    - sls: docker.manager.manager
    - tgt: {{ node }}
    - require_in:
      - salt: update-salt-mine-{{ node }}

{% else %}

docker-swarm-add-worker-{{ node }}:
  salt.state:
    - sls: docker.worker.worker
    - tgt: {{ node }}

{% endif %}

{% endfor %}
