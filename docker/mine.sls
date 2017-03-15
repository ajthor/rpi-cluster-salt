# Salt Mine for getting addresses and keys.
/etc/salt/minion.d/swarm.conf:
  file.managed:
    - source: salt://docker/manager/swarm.conf
