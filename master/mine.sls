# Salt Mine for getting addresses and keys.
/etc/salt/minion.d/swarm.conf:
  file.managed:
    - source: salt://master/swarm.conf
    - require:
      - pkg: docker-engine
