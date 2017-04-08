# Configure the Salt pillar.

# The `files` variable in jinja holds a list of all of the pillar configuration
# files which will be added to the master. These should be added without
# leading slashes, just as you would specify them in the top file.
{% set files = ['config'] %}

# Add pillar files.
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

# Update the Salt pillar.
update-salt-pillar:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: 'rpi-master'
    - require:
      - file: /srv/pillar/top.sls
{% for f in files %}
      - file: /srv/pillar/{{ f }}.sls
{%- endfor %}
