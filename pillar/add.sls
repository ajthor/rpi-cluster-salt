# Macro for adding pillar files to the master.
# NOTE: No jinja templating should occur in the pillar files. The templates
# should be evaluated at runtime by Salt.
{% macro add_pillar_data(files) %}
{%- for file in files %}
/srv/pillar/{{ file }}:
  file.managed:
    - source: salt://{{ file }}
{% endfor -%}
{% endmacro %}
