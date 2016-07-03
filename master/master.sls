git@github.com:ajthor/rpiomega-salt-provisioner.git:
  git.latest:
    - rev: master
    - target: /srv/salt
    - require:
      pkg: git
