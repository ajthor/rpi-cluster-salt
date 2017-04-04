# This is the main list of salt states to apply to each of the nodes in the
# cluster. We will apply the common configuration and install Docker on each
# node.

base:
  '*':
    - common/common
