consul:
  dockerng.running:
    - name: consul
    - image: hypriot/rpi-consul
    - cmd: agent -server -data-dir /data -bootstrap-expect 1 -ui-dir /ui
    - detach: True
    - ports:
      - 8500
    - port_bindings:
      - 8500:8500
    - volumes:
      - /data
    - restart_policy: always
    - require:
      - pkg: docker-installation
