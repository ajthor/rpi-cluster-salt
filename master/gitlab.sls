gitlab-dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - openssh-server
      - ca-certificates
      - apt-transport-https

gitlab-repo:
  pkgrepo.managed:
    - name: deb https://packages.gitlab.com/gitlab/raspberry-pi2/raspbian/ jessie main
    - file: /etc/apt/sources.list.d/gitlab_raspberry-pi2.list
    - key_url: https://packages.gitlab.com/gpg.key

gitlab-installation:
  pkg.latest:
    - name: gitlab-ce
    - refresh: True
    - require:
      - pkgrepo: gitlab-repo

gitlab-configuration:
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://master/templates/gitlab.rb.j2
    - template: jinja
    - defaults:
      hostname: "{{ grains['host'] }}.local"
    - require:
      - pkg: gitlab-installation

gitlab-reconfigure:
  cmd.run:
    - name: gitlab-ctl reconfigure
    - require:
      - file: gitlab-configuration
