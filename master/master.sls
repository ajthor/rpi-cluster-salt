# This state file makes sure the Master is configured properly and has all of
# the necessary files for the system.

# Make sure GitPython is installed.
pip-GitPython:
  pip.installed:
    - name: GitPython
    - require:
      - pkg: python-pip
