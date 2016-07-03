salt-provisioner-repo:
  git.latest:
    - name: https://github.com/ajthor/rpiomega-salt
    - target: /srv/salt
    - user: pi
