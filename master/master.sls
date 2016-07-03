salt-provisioner-repo:
  git.latest:
    - name: https://github.com/ajthor/rpiomega-salt
    - rev: development
    - target: /srv/salt
    - user: pi
    - require:
      - pkg: git
