base:
  'G@os:Raspbian':
    - match: grain
    - common/common
    - common/b2

  'rpiomega-node-?':
    - nodes/docker

  'rpiomega-master':
    - master/master
    - master/gitlab
    - master/docker
