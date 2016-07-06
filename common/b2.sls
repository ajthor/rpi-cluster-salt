b2:
  git.latest:
    - name: https://github.com/Backblaze/B2_Command_Line_Tool.git
    - target: /tmp/B2_Command_Line_Tool
  cmd.run:
    - name: 'python /tmp/B2_Command_Line_Tool/setyp.py install'
    - require:
      - pkg: common-pkgs
