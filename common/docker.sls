docker-repo:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ jessie main
    - key_url: https://packagecloud.io/gpg.key

docker-installation:
  pkg.latest:
    - pkgs:
      - docker-hypriot
      - docker-compose
      - docker-machine
    - require:
      - docker-repo

docker-service:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker-installation
