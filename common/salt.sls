# saltstack:
#   pkgrepo.managed:
#     - name: deb http://repo.saltstack.com/apt/debian/8/armhf/latest jessie main
#     - file: /etc/apt/sources.list.d/saltstack.list
#     - key_url: https://repo.saltstack.com/apt/debian/8/armhf/latest/SALTSTACK-GPG-KEY.pub
#     - refresh_db: true
#     - unless: which salt
#     - require_in:
#       - pkg: salt-master
#       - pkg: salt-minion
