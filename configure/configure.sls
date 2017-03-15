# This state file is used by Salt to install the configuration files necessary
# or our system to work properly. It should be used when setting up the Master
# and when bootstrapping new nodes, but does not need to be run continually,
# which means it is not part of the normal configuration process.

{{ if grains['host'] == 'rpiomega-master' }}
  {% set master = true %}
{{ endif }}

# Install Salt on the target system.
salt-bootstrap:
  cmd.run:
    - name: curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
    - cwd: /tmp
    - unless: which salt

salt-installation:
  cmd.run:
{{ if master }}
    - name: sh bootstrap-salt.sh -M
{{ else }}
    - name: sh bootstrap-salt.sh
{{ endif }}
    - cwd: /tmp
    - unless: which salt
    - requires:
      - cmd: salt-bootstrap

# Set up the services for salt.
{{ if master }}
salt-master-service:
  service.running:
    - name: salt-master
    - enable: True
    - reload: True
    - watch:
      - file: /etc/salt/master
{{ endif }}

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
  pkg.latest:
    - pkgs:
      - python-pip
      - python3-pip
    - unless: which pip
    - require:
      - pkg: python

# Python libraries for all systems.
pip-GitPython:
  pip.installed:
    - name: GitPython
    - require:
      - pkg: python-pip

# Ensure the configuration is up-to-date on all systems.
{{ if master }}
master-configuration:
  file.managed:
    - name: /etc/salt/master
    - source: salt://bootstrap/templates/master
    - template: jinja
    - defaults:
      hostname: "rpiomega-master.local"
{{ endif }}

# For the master, we need to set the master to the local loopback address,
# which is 127.0.0.1
minion-configuration:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://bootstrap/templates/minion
    - template: jinja
    - defaults:
{{ if master }}
      master_ip: "127.0.0.1"
{{ else }}
      master_ip: "rpiomega-master.local"
{{ endif }}
