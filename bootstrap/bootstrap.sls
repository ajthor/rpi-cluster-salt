# This state file is used by salt-ssh to install Salt and configure the files
# necessary for our system to work properly. It is only used when bootstrapping
# new nodes.

{% if grains['host'] == 'rpi-master' %}
  {% set master = true %}
  {% set master_host = '127.0.0.1' %}
{% else %}
  {% set master = false %}
  {% set master_host = 'rpi-master.local' %}
{% endif %}

# Install Salt on the target system.
{% if master %}

salt-packages:
  pkg.installed:
    - pkgs:
      - salt-ssh
    - unless:
      - which salt-ssh

{% else %}

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
    - require:
      - cmd: salt-bootstrap

{% endif %}

# Set up the services for salt-minion.
salt-minion-service:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - file: /etc/salt/minion

# Ensure the minion configuration is up-to-date on all systems.
minion-configuration:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://bootstrap/templates/minion
    - template: jinja
    - defaults:
      master: {{ master_host }}

{% if master %}

# Set up the services for salt-master.
salt-master-service:
  service.running:
    - name: salt-master
    - enable: True
    - watch:
      - file: /etc/salt/master

# Ensure the master configuration is up-to-date on all systems.
master-configuration:
  file.managed:
    - name: /etc/salt/master
    - source: salt://bootstrap/templates/master

# Ensure the roster configuration is up-to-date on all systems.
roster-configuration:
  file.managed:
    - name: /etc/salt/roster
    - source: salt://bootstrap/templates/roster

{% endif %}
