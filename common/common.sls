# This state file installs common development software, such as GCC, make, Git,
# Python, and Node.js on your system. The complete list can be found by looking
# at the code below.

# Add the 'pi' user to the 'sudo' group.
sudo-user:
  group.present:
    - name: sudo
    - addusers:
      - pi

# Install common packages for development, such as Git and GCC.
common:
  pkg.installed:
    - pkgs:
      - gcc
      - make
      - git-core

# Ensure that Python is installed on the system.
python:
  pkg.installed:
    - pkgs:
      - python2.7
      - python3.4

# Install PIP from the apt Raspbian repo.
python-pip:
  pkg.installed:
    - pkgs:
      - python-pip
      - python3-pip
    - unless: which pip
    - require:
      - pkg: python

# Install Node.js on all systems.
# nodejs-repo:
#   pkgrepo.managed:
#     - name: deb https://deb.nodesource.com/node_7.x jessie main
#     - file: /etc/apt/sources.list.d/nodesource.list
#     - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
nodejs-bootstrap:
  cmd.run:
    - name: curl -o nodesetup.bash -sL https://deb.nodesource.com/setup_7.x
    - cwd: /tmp
    - unless: which nodejs

nodejs-repo:
  cmd.run:
    - name: sudo -E bash nodesetup.bash
    - cwd: /tmp
    - unless: which nodejs

nodejs:
  pkg.installed:
    - pkgs:
      - nodejs
      - npm
    - unless:
      - which nodejs
      - which npm
    - require:
      - cmd: nodejs-repo
