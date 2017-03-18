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

# Install pip from apt.
python-pip:
  pkg.installed:
    - pkgs:
      - python-pip
      - python3-pip
    - unless: which pip
    - require:
      - pkg: python

# Install Node.js on all systems.
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
    - unless:
      - which nodejs
    - require:
      - cmd: nodejs-repo
