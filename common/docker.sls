docker-repo:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ jessie main
    - file: /etc/apt/sources.list.d/hypriot.list
    - key_url: https://packagecloud.io/gpg.key

docker-installation:
  pkg.latest:
    - pkgs:
      - docker-hypriot
      - docker-compose
      - docker-machine
    - require:
      - pkgrepo: docker-repo

docker-user:
  group.present:
    - name: docker
    - members:
      - pi

docker-service:
  service.running:
    - name: docker
    - enable: True
    - reload: True
    - require:
      - pkg: docker-installation
