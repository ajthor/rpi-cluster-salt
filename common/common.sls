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

python-pip:
  cmd.run: easy_install pip
    - require:
      - pkg: python-pkgs
    - reload_modules: True

docker-py:
  pip.installed:
    - name: docker-py >= 0.6.0
    - require:
      - pkg: python-pip

python-dateutil:
  pip.installed:
    - name: python-dateutil
    - require:
      - pkg: python-pip
