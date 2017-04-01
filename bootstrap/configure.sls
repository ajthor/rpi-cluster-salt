# This file configures Salt by making sure the pillar files are on the master
# and by making sure the configuration files exist on the master and minions.

{% set files = ['config'] %}

{% if grains['host'] == 'rpi-master' %}
# Master-only configuration. Here, we need to create files that are exclusive
# to the master. These are things like the pillar files, the master and roster
# configuration files, etc.

/srv/pillar/top.sls:
  file.managed:
    - source: salt://pillar/top.sls
    - unless: test -f "/srv/pillar/top.sls"

# Add pillar files to master.
{% for f in files %}
/srv/pillar/{{ f }}.sls:
  file.managed:
    - source: salt://pillar/{{ f }}.sls
    - unless: test -f "/srv/pillar/{{ f }}.sls"
{% endfor %}

# Update the Salt pillar so that it has all relevant data.
update-salt-pillar:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: 'rpi-master'
    - onchanges:
      - file: /srv/pillar/top.sls
      - file: /srv/pillar/config.sls
    - require:
      - file: /srv/pillar/top.sls
      - file: /srv/pillar/config.sls

# Ensure the master configuration is up-to-date.
/etc/salt/master:
  file.managed:
    - source: salt://bootstrap/templates/master
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
    - context:
{% if grains['host'] == 'rpi-master' %}
      master: 127.0.0.1
{% else %}
      # NOTE: The template file tries to pull whatever value is in the pillar
      # for the `master_hostname`. If no hostname is found in the pillar, this
      # will default to `rpi-master.local`.
      master: {{ salt['pillar.get']('config:master_hostname') }}
{% endif %}

# Set up the services for salt-minion.
salt-minion-service:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - file: /etc/salt/minion
