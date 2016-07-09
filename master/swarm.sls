swarm-master:
  dockerng.running:
    - name: swarm-manager
    - image: hypriot/rpi-swarm
    - cmd: manage -H tcp://{{ grains['ip_interfaces']['eth0'] }}:4000 --advertise {{ grains['localhost'] }}.local:4000 consul://{{ grains['ip_interfaces']['eth0'] }}:8500
    - detach: True
    - ports:
      - 4000
    - require:
      - pkg: docker-installation
