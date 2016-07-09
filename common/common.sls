common-pkgs:
  pkg.latest:
    - pkgs:
      - gcc
      - make
      - git
      - apt-transport-https

python-pkgs:
  pkg.latest:
    - pkgs:
      - python2.7
      - python3.4

pip-install:
  cmd.run:
    - name: easy_install pip
    - unless: which pip
    - require:
      - pkg: python-pkgs
    - reload_modules: True

docker-py:
  pip.installed:
    - name: docker-py >= 0.6.0
    - require:
      - cmd: pip-install

python-dateutil:
  pip.installed:
    - name: python-dateutil
    - require:
      - cmd: pip-install
