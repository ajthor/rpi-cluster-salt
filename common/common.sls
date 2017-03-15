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
  pkg.latest:
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
  pkg.latest:
    - pkgs:
      - python-pip
      - python3-pip
    - unless: which pip
    - require:
      - pkg: python

# Python libraries for all systems.
# pip-GitPython:
#   pip.installed:
#     - name: GitPython
#     - require:
#       - pkg: python-pip

# Install Node.js on all systems.
node:
  pkg.installed:
    - pkgs:
      - nodejs
      - npm
