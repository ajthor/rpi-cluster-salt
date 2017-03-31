# This state file installs Salt using the bootstrap script from
# https://bootstrap.saltstack.com.

# Run the Salt install script.
salt-bootstrap:
  cmd.run:
    - name: curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
    - cwd: /tmp
    - unless: which salt-minion

salt-installation:
  cmd.run:
{% if grains['host'] == 'rpi-master' %}
    - name: sh bootstrap-salt.sh -M
{% else %}
    - name: sh bootstrap-salt.sh
{% endif %}
    - cwd: /tmp
    - unless: which salt-minion
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
