base:
  'G@os:Raspbian':
    - match: grain
    - common/common
    - common/b2

  'rpiomega-master':
    - master/master
    - master/gitlab
    - master/docker
    - master/consul
    - master/swarm

  'rpiomega-node-?':
    - nodes/docker
    - nodes/swarm
