
# This is the main list of salt states to apply to each of the nodes in the
# cluster. We have separate lists for the 'master' and the 'nodes'.

base:
  '*':
    - common/common
    - common/docker

  'rpiomega-master':
    - master/mine
    - master/master

  'rpiomega-node-?':
    - nodes/nodes

# NOTE: Docker needs containers for Consul and potentially GitLab.
