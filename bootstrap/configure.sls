# This file configures Salt by making sure the pillar files are on the master
# and by making sure the configuration files exist on the master and minions.

{% set files = ['config'] %}

{% if grains['host'] == 'rpi-master' %}
# Master-only configuration. Here, we need to create files that are exclusive
# to the master. These are things like the pillar files, the master and roster
# configuration files, etc.

# Add pillar files to master.
{% for f in files %}
/srv/pillar/{{ f }}.sls:
  file.managed:
    - source: salt://pillar/{{ f }}.sls
    - makedirs: True
    - unless: test -f "/srv/pillar/{{ f }}.sls"
{%- endfor %}

/srv/pillar/top.sls:
  file.append:
    - source: salt://pillar/top.sls
    - template: jinja
    - defaults:
        # NOTE: Need extra spaces here to make this work. Add an extra tab for
        # defaults in file.append states using jinja templating.
        # https://github.com/saltstack/salt/issues/18686
        files: {{ files }}
    - require:
{% for f in files %}
      - file: /srv/pillar/{{ f }}.sls
{%- endfor %}

# Update the Salt pillar so that it has all relevant data.
update-salt-pillar:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: 'rpi-master'
    - onchanges:
{% for f in files %}
      - file: /srv/pillar/{{ f }}.sls
{%- endfor %}
    - require:
{% for f in files %}
      - file: /srv/pillar/{{ f }}.sls
{%- endfor %}

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

# Set up the services for salt-minion.
salt-minion-service:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - file: /etc/salt/minion
