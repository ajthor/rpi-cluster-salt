
{% if grains['host'] == 'rpi-master' %}
  {% set is_master = true %}
{% else %}
  {% set is_master = false %}
{% endif %}

{% if is_master %}
# master-only configuration. Here, we need to create files that are exclusive
# to the master. These are things like the pillar files, the master and roster
# configuration files, etc.

# Add pillar files to master.
/srv/pillar/top.sls:
  file.managed:
    - source: salt://pillar/top.sls
    - unless: test -f "/srv/pillar/top.sls"

/srv/pillar/config.sls:
  file.managed:
    - source: salt://pillar/config.sls
    - unless: test -f "/srv/pillar/config.sls"

# Update the Salt pillar so that it has all relevent data.
update-salt-pillar:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: 'rpi-master'
    - require:
      - file: /srv/pillar/top.sls
      - file: /srv/pillar/config.sls

# Ensure the master configuration is up-to-date.
/etc/salt/master:
  file.managed:
    - source: salt://bootstrap/templates/master
    - unless: test -f "/etc/salt/master"

# Ensure the roster configuration file exists.
/etc/salt/roster:
  file.managed:
    - source: salt://bootstrap/templates/roster
    - template: jinja
    - unless: test -f "/etc/salt/roster"
{% endif %}

# Ensure the minion configuration is up-to-date on all systems.
/etc/salt/minion:
  file.managed:
    - source: salt://bootstrap/templates/minion
    - template: jinja
    - context:
{% if is_master %}
      master: 127.0.0.1
{% else %}
      master: {{ salt['pillar.get']('config:master_hostname') }}
{% endif %}
