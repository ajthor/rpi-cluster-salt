# This file configures Salt by making sure the pillar files are on the master
# and by making sure the configuration files exist on the master and minions.

# Ensure the master configuration is up-to-date.
/etc/salt/master:
  file.managed:
    - source: salt://bootstrap/templates/master
    - template: jinja
    - unless: test -f "/etc/salt/master"
    - require:
      - salt: update-salt-pillar

# Ensure the roster configuration file exists.
/etc/salt/roster:
  file.managed:
    - source: salt://bootstrap/templates/roster
    - template: jinja
    - unless: test -f "/etc/salt/roster"
    - require:
      - salt: update-salt-pillar
{% endif %}

# Ensure the minion configuration is up-to-date on all systems.
/etc/salt/minion:
  file.managed:
    - source: salt://bootstrap/templates/minion
    - template: jinja
{% if grains['host'] == 'rpi-master' %}
    - defaults:
      master: 127.0.0.1
{% endif %}

# Restart salt-minion.
restart-salt-minion:
  cmd.run:
    - name: 'salt-call --local service.restart salt-minion'
    - bg: True
    - onchanges:
      - file: /etc/salt/minion
