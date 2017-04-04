# This state file is used by salt-ssh to install Salt and configure the files
# necessary for our system to work properly. It is only used when bootstrapping
# new nodes.

# Install Salt on the target system.
install-salt:
  salt.state:
    - sls: bootstrap.install
    - tgt: '*'

# Configure the Salt pillar.

# The `files` variable in jinja holds a list of all of the pillar configuration
# files which will be added to the master. These should be added without
# leading slashes, just as you would specify them in the top file.
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
    - source: salt://pillar/top.tmpl
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
    - require:
{% for f in files %}
      - file: /srv/pillar/{{ f }}.sls
{%- endfor %}

{% endif %}

configure-salt:
  salt.state:
    - sls: bootstrap.configure
    - tgt: '*'
