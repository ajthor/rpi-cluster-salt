consul:
  dockerng.running:
    - name: consul
    - image: hypriot/rpi-consul
    - cmd: -server -data-dir /data -bootstrap-expect 1 -ui-dir /ui
    - detach: True
    - ports:
      - 8500
    - restart_policy: always
    - require:
      - docker-installation
