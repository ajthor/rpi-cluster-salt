# This state file is used by salt-ssh to install Salt and configure the files
# necessary for our system to work properly. It is only used when bootstrapping
# new nodes.

# Install Salt on the target system.
salt-bootstrap:
  cmd.run:
    - name: curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
    - cwd: /tmp
    - unless: which salt-minion

salt-installation:
  cmd.run:
    - name: sh bootstrap-salt.sh
    - cwd: /tmp
    - unless: which salt-minion
    - requires:
      - cmd: salt-bootstrap

# Set up the services for salt.
salt-minion-service:
  service.running:
    - name: salt-minion
    - enable: True
    - reload: True
    - watch:
      - file: /etc/salt/minion

# Ensure that Python is installed on the system.
python:
  pkg.installed:
    - pkgs:
      - python2.7
      - python3.4

# Install PIP from the apt Raspbian repo.
python-pip:
  pkg.installed:
    - pkgs:
      - python-pip
      - python3-pip
    - unless: which pip
    - require:
      - pkg: python

# Ensure the configuration is up-to-date on all systems.
minion-configuration:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://bootstrap/templates/minion
    - template: jinja
    - defaults:
      master: "rpiomega-master.local"
