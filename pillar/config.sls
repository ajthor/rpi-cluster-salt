# This file holds the basic configuration variables for Salt to use in state
# files. Configure your system here to use the best configuration for your
# needs and then refresh the pillar data on all minions using:
# `salt '*' saltutil.refresh_pillar`

# Configuration variables can be retrieved using jinja templating with the
# syntax:
# - pillar['config']['variable']
# - salt['pillar.get']('pkgs:apache', 'httpd')
config:
  cluster:
    - master_hostname: rpi-master
    - master_ipaddress: rpi-master.local
    - minions:
      - rpi-node-1
      - rpi-node-2
      - rpi-node-3

# Raspbian-specific configuration.
{%- if grains['os'] == 'Raspbian' -%}

{%- endif -%}
