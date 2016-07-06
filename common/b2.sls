b2-script:
  git.latest:
    - name: https://github.com/Backblaze/B2_Command_Line_Tool.git
    - target: /tmp/B2_Command_Line_Tool
    - require:
      - pkg: common-pkgs

b2-CLI:
  cmd.run:
    - name: 'python /tmp/B2_Command_Line_Tool/setyp.py install'
    - require:
      - git: b2-script
