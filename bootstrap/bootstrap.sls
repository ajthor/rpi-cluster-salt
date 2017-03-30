# This state file is used by salt-ssh to install Salt and configure the files
# necessary for our system to work properly. It is only used when bootstrapping
# new nodes.

{% if grains['host'] == 'rpi-master' %}
  {% set is_master = true %}
{% else %}
  {% set is_master = false %}
{% endif %}

# Install Salt on the target system.
{% if is_master %}
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

include:
  - bootstrap.configure
