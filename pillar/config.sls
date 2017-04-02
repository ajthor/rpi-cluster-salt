# This file holds the basic configuration variables for Salt to use in state
# files. Configure your system here to use the best configuration for your
# needs and then refresh the pillar data on all minions using:
# `salt '*' saltutil.refresh_pillar`

# Configuration variables can be retrieved using jinja templating with the
# syntax:
# - pillar['config']['variable']
# - salt['pillar.get']('pkgs:apache', 'httpd')
config:
  # The hostname of the master. Will be passed to all minions who are added
  # to the cluster.
  master_host: rpi-master
  master_hostname: rpi-master.local

{% if grains['host'] == 'rpi-master' %}
  # Minions can be added to the roster file directly, or they can be added
  # here so that they can be added using the configuration script. Minions
  # added in this way will retain all of the default settings, such as
  # username and password.
  minions:
    - rpi-node-1
    - rpi-node-2
    - rpi-node-3
  gitfs_remotes:
    - https://github.com/ajthor/rpi-cluster-salt.git
    # To add more git remotes, you can add them manually or add them here.
    # New git remotes can be added using the configuration script.
    # For example:
    # - https://github.com/ajthor/rpi-cluster-docker.git:
    #   - base: development
{% endif %}

# Raspbian-specific configuration.
{% if grains['os'] == 'Raspbian' %}

{% endif %}
