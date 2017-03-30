# This state file is used by salt-ssh to install Salt and configure the files
# necessary for our system to work properly. It is only used when bootstrapping
# new nodes.

{%- if grains['host'] == salt['pillar.get']('config:master_hostname', 'rpi-master') -%}
  {%- set is_master = true -%}
{%- else -%}
  {%- set is_master = false -%}
{%- endif -%}

# Install Salt on the target system.
{%- if is_master -%}

salt-packages:
  pkg.installed:
    - pkgs:
      - salt-ssh
    - unless:
      - which salt-ssh

{%- else -%}

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

{%- endif -%}

# Set up the services for salt-minion.
salt-minion-service:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - file: /etc/salt/minion

# Ensure the minion configuration is up-to-date on all systems.
/etc/salt/minion:
  file.managed:
    - source: salt://bootstrap/templates/minion
    - template: jinja
    - context:
{%- if is_master -%}
      master: {{ salt['pillar.get']('config:master_ipaddress') }}
{%- else -%}
      master: {{ master_ip }}
{%- endif -%}

{%- if is_master -%}
# Ensure the master configuration is up-to-date.
/etc/salt/master:
  file.managed:
    - source: salt://bootstrap/templates/master

# Ensure the roster configuration file exists.
/etc/salt/roster:
  file.managed:
    - source: salt://bootstrap/templates/roster
    - template: jinja

# Add pillar files to master.
{%- set pillar_files = ['config.sls', 'top.sls'] -%}
{%- for file in pillar_files %}
/srv/pillar/{{ file }}:
  file.managed:
    - source: salt://pillar/{{ file }}
{% endfor -%}

{%- endif -%}
