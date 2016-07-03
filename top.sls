base:
  'os:Raspbian':
    - match: grain
    - common/raspbian/common
    - common/raspbian/b2

  'rpiomega-node-?':
    - nodes/docker
    - nodes/swarm

  'rpiomega-master':
    - master/master
    - master/gitlab
    - master/docker
    - master/swarm
