docker-installation:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ jessie main
    - key_url: https://packagecloud.io/gpg.key
  pkg.latest:
    - pkgs:
      - docker-hypriot
      - docker-compose
      - docker-machine
  service.running:
    - name: docker
    - enable: True
