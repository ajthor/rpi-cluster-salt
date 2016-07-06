base:
  'rpiomega-master':
    - master/master

  '*':
    - common/common
    - common/b2
    - common/docker

  'rpiomega-master':
    - master/gitlab
    - master/consul
    - master/swarm

  'rpiomega-node-?':
    - nodes/swarm
