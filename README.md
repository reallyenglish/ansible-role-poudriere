# ansible-role-poudriere

Setup poudriere, a package builder for FreeBSD

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| poudriere\_conf | path to poudriere.conf | /usr/local/etc/poudriere.conf |
| poudriere\_config | a dict of config (see example below) | {} |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-poudriere
  vars:
    poudriere_config:
      NO_ZFS: "yes"
      GIT_URL: "https://github.com/reallyenglish/freebsd-ports.git"
      FREEBSD_HOST: "ftp://ftp.jp.freebsd.org"
      RESOLV_CONF: /etc/resolv.conf
      BASEFS: /usr/local/poudriere
      DISTFILES_CACHE: /usr/ports/distfiles
      SVN_HOST: svn.FreeBSD.org
      CHECK_CHANGED_OPTIONS: verbose
      NOLINUX: "yes"
    poudriere_enable_sudo:
    poudriere_ports:
      10_3_re:
        method: git
        branch: 10_3_re
      freebsd:
        method: svn
    poudriere_jails:
      "10_3":
        method: http
        version: 10.3-RELEASE
    poudriere_hooks:
      jail: |
        #!/bin/sh
        echo "args=$*"
      builder: |
        #!/bin/sh
        echo "args=$*"
```

# License


# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
