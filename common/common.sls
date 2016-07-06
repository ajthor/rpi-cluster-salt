common-pkgs:
  pkg.latest:
    - pkgs:
      - gcc
      - make
      - git

python-pkgs:
  pkg.latest:
    - pkgs:
      - python2.7
      - python3.4
      - python-pip

pip-pkgs:
  pip.installed:
    - name: docker-py >= 0.6.0
    - require:
      - pkg: python-pkgs
  pip.installed:
    - name: python-dateutil
    - require:
      - pkg: python-pkgs
