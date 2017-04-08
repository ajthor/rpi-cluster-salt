# This file is meant to be run using Salt orchestrate, using a command such as:
# `sudo salt-run state.orchestrate salt.bootstrap`

# Configure pillar.
configure-pillar:
  salt.state:
    - sls: salt.pillar
    - tgt: 'rpi-master'

# Install Salt.
install-salt:
  salt.state:
    - sls: salt.install
    - tgt: '*'

# Configure Salt.
configure-salt:
  salt.state:
    - sls: salt.configure
    - tgt: '*'
