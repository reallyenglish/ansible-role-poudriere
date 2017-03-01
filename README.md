# ansible-role-poudriere

Setup poudriere, a package builder for FreeBSD

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `poudriere_conf` | path to `poudriere.conf` | `/usr/local/etc/poudriere.conf` |
| `poudriere_config_default` | defaults for `poudriere_config` | see below |
| `poudriere_config` | dict of config that overrides `poudriere_config_default` | `{}` |

## `poudriere_config_default`

`BASEFS` and `DISTFILES_CACHE` are mandatory. See `poudriere.conf.sample` for
details.

```yaml
poudriere_config_default:
  FREEBSD_HOST: ftp://ftp.freebsd.org
  SVN_HOST: svn.FreeBSD.org
  BASEFS: /usr/local/poudriere
  RESOLV_CONF: /etc/resolv.conf
  USE_TMPFS: "yes"
  DISTFILES_CACHE: /usr/ports/distfiles
```

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-poudriere
  vars:
    poudriere_config:
      FREEBSD_HOST: ftp://ftp.jp.freebsd.org
      NO_ZFS: "yes"
      GIT_URL: "https://github.com/reallyenglish/freebsd-ports.git"
      CHECK_CHANGED_OPTIONS: verbose
      NOLINUX: "yes"
    poudriere_enable_sudo:
    poudriere_ports:
      10_3_re:
        method: git
        branch: 10_3_re
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

```
Copyright (c) 2016 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
