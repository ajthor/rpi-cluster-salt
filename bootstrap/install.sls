# This state file installs Salt using the bootstrap script from
# https://bootstrap.saltstack.com.

# Run the Salt install script.
salt-bootstrap:
  cmd.run:
    - name: curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
    - cwd: /tmp
    - unless:
      - which salt-master
      - which salt-minion

salt-installation:
  cmd.run:
    - name: sh bootstrap-salt.sh {% if grains['host'] == 'rpi-master' %}-M{% endif %}
    - cwd: /tmp
    - unless:
      - which salt-master
      - which salt-minion
    - require:
      - cmd: salt-bootstrap

{% if grains['host'] == 'rpi-master' %}
salt-ssh:
  pkg.installed:
    - pkgs:
      - salt-ssh
    - unless:
      - which salt-ssh
{% endif %}
