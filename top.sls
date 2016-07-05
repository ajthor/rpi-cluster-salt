base:
  'os:Raspbian':
    - match: grain
    - common/raspbian/common
    - common/raspbian/b2
    - common/docker

  'rpiomega-master':
    - master/master
    - master/gitlab
    - master/consul
    - master/swarm

  'rpiomega-node-?':
    - nodes/swarm
