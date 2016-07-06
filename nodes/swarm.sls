swarm-node:
  dockerng.running:
    - name: swarm-{{ grains['server_id'] }}
    - image: hypriot/rpi-swarm
    - cmd: join --advertise {{ grains['host'] }}.local:2375 consul://{{ grains['master'] }}:8500
    - detach: True
    - ports:
      - 2375
    - restart_policy: always
    - require:
      - docker-installation
