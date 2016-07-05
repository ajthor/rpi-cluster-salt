base:
  'G@os:Raspbian':
    - match: grain
    - common/common
    - common/b2
    - common/docker

  'rpiomega-master':
    - master/master
    - master/gitlab
    - master/consul
    - master/swarm

  'rpiomega-node-?':
    - nodes/swarm
