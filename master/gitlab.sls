gitlab-dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - openssh-server
      - ca-certificates
      - apt-transport-https

gitlab-installation:
  pkgrepo.managed:
    - name: deb https://packages.gitlab.com/gitlab/raspberry-pi2/raspbian/ jessie main
    - file: /etc/apt/sources.list.d/gitlab_raspberry-pi2.list
    - key_url: https://packages.gitlab.com/gpg.key
  pkg.latest:
    - name: gitlab-ce
    - refresh: True
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://srv/salt/master/templates/gitlab.rb.j2
    - template: jinja
    - defaults:
      hostname: "{{ grains['host'] }}"
      port: 8081
  cmd.run:
    - name: gitlab-ctl reconfigure
