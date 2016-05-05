ansible-role-poudriere
======================

Setup poudriere, a package builder for FreeBSD

Requirements
------------

None

Role Variables
--------------

| Variable | Description | Default |
|----------|-------------|---------|
| poudriere\_conf | path to poudriere.conf | /usr/local/etc/poudriere.conf |
| poudriere\_config | a dict of config (see example below) | {} |

Dependencies
------------

None

Example Playbook
----------------

    - hosts: all
      roles:
        - ansible-role-poudriere
      vars:
        poudriere_config:
          NO_ZFS: "yes"
          GIT_URL: "https://github.com/reallyenglish/freebsd-ports.git"
          FREEBSD_HOST: "ftp://ftp.jp.freebsd.org"

License
-------

BSD

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
