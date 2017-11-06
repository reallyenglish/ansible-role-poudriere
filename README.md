# ansible-role-poudriere

Setup poudriere, a package builder for FreeBSD

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `poudriere_conf` | path to `poudriere.conf` | `/usr/local/etc/poudriere.conf` |
| `poudriere_conf_d` | path to `poudriere.d` directory | `/usr/local/etc/poudriere.d` |
| `poudriere_config_default` | defaults for `poudriere_config` | see below |
| `poudriere_config` | dict of config that overrides `poudriere_config_default` | `{}` |
| `poudriere_ports` | see below | `{}` |
| `poudriere_jails` | see below | `{}` |
| `poudriere_hooks` | see below | `{}` |
| `poudriere_make_conf_files` | see below | `[]` |
| `poudriere_pkg_repo_signing_key` | content of key with which `poudriere` sign packages | `""` |

## `poudriere_config_default`

`BASEFS` and `DISTFILES_CACHE` are mandatory. See `poudriere.conf.sample` for
details.

```yaml
poudriere_config_default:
  FREEBSD_HOST: https://ftp.freebsd.org
  SVN_HOST: svn.FreeBSD.org
  BASEFS: /usr/local/poudriere
  RESOLV_CONF: /etc/resolv.conf
  USE_TMPFS: "yes"
  DISTFILES_CACHE: /usr/ports/distfiles
```
## `poudriere_ports`

| Key | Description | Mandatory |
|-----|-------------|-----------|
| `method` | method to use to create the ports tree | no |
| `branch` | branch to checkout | no |
| `extra_flags` | additional flags to `poudriere(8)` when creating ports tree | no |
| `path` | path to the ports tree | no |
| `state` | state of the ports, either `present` or `absent` | yes |

## `poudriere_jails`

| Key | Description | Mandatory |
|-----|-------------|-----------|
| `method` | method to use to create the jail | yes |
| `version` | version of FreeBSD to use in the jail | yes |
| `extra_flags` | additional flags to `poudriere(8)` when creating the jail | no |
| `state` | state of the jail, either `present` or `absent` | yes |

## `poudriere_hooks`

| Key | Description |
|-----|-------------|
| hook name | the value is the content of the hook script. see [hook](https://github.com/freebsd/poudriere/wiki/hooks) for possible hook names |

## `poudriere_pkg_repo_signing_key`

When `poudriere_pkg_repo_signing_key` is defined,
`poudriere_config['PKG_REPO_SIGNING_KEY']` must be set to path to the key file.

## `poudriere_make_conf_files`

| Key | Description | Mandatory? |
|-----|-------------|------------|
| `name` | file name of the `make.conf(5)` | yes | 
| `state` | create the file if `present`, remove it if `absent` | yes |
| `content` | the content of the `make.conf(5)` | yes if `state` is `present` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - name: reallyenglish.git
    - ansible-role-poudriere
  vars:
    poudriere_make_conf_files:
      - name: make.conf
        state: present
        content: |
          LICENSES_ACCEPTED=MSPAT OSI
          MAKE_JOB_NUMBERS=3
    poudriere_config:
      FREEBSD_HOST: http://ftp.freebsd.org
      NO_ZFS: "yes"
      GIT_URL: "https://github.com/reallyenglish/freebsd-ports-mini.git"
      CHECK_CHANGED_OPTIONS: verbose
      NOLINUX: "yes"
      PKG_REPO_SIGNING_KEY: /usr/local/etc/poudriere/keys/my.key
    # openssl genrsa -out my.key 2048
    # openssl rsa -in my.key -out my.pub -pubout
    poudriere_pkg_repo_signing_key: |
      -----BEGIN RSA PRIVATE KEY-----
      MIIEogIBAAKCAQEAwoMg0XK2SdEaz8b8O6rYf+lzDx+ElBXr2ARmFCG+SzKmHf8+
      zL4+gKMLFv3DytKE2WiZs+WNCKCGYPmH6Sg5DOJxpO/NhpqiHSngigB7B2XzZeSC
      erTiqn4Qw17/ydd1tRFzVS/BPPYyoUnFdZ4+xgItaPfa6Ns32mwqUb9mE2EEx66u
      yU1GAiI7yO1VRYzrHQwyVB74c72mlC/kJaUaBLoE9dWfyegRRycRK3sSxMYX0eYE
      5/EzlmRK3BBLchH57B0u2WWR75MWUfkTWh1pAKB/Dxl74fmQT+yvNKk9/U8mo9zV
      oVw0H7dphgglS2fXXvyFIn9TIVGS5zbe2C4scQIDAQABAoIBAEu5lQs1Z3YxbAi7
      5PKtvn99uQeIM6sbJagBfmQUButrmnRPLHm1DswxrV2UCadqccHaEQySL2fOZsJW
      Iu1IdX1ooumdWhwvEzHbXckcCsmEjU97uLhgt2W8knYdA+Pmd7K4Sng9kTNUfb2A
      5Ni3dKTNsDQPWjAROBtWxNrycqDUFIFiN/VYFsPb4cQHxJLx62l8xZklC1jk9rmE
      G8CacImUMmorTD5QUbhVeWDvb0Szpn73kDQmYkKQ8Eq4zOlrWXoTYAPxHrbX85pT
      GqkzzcuYiq7ByP3LWP3GvZKCjgONwBVTEsXjPtbrOTDr7JshMjrJSl40DCYUGOvh
      a26DXwkCgYEA6eUyKmGHW0BM320cT5bHSkwsg0uoidSs1IcqR+lFyL5/3Wauxfo1
      wxiKJNYzXC84UahCzPP3cS+Bpy1hfDqvDIRxLuTNGBxvDMFmiQHWnXsXdJmEInIB
      rBnN3nGiZFUrKmCuaBVo/tweft4Fe9JulB/efDXcHOcg7mvCL4u1LjMCgYEA1OUb
      o2n1wbMjOeI7kvhf0pbL/Jgt0sIj8tYRqHhFihrk7aQVv87O0iOLOgKN2McXTdow
      qXouO0dJhDMydJHT4Lpmueguu+1cuSwB7Lt3ETOjBn41KzTOYlgJeGR3w6ltYCWw
      0zLUmRPlfiZ77yLThbXCvJKr0TTo6VqU+unVTssCgYAVasBCMzYCvAuN9d6+xu6u
      tfTpfNcM7+V3fHz5ormaHR92NX3RcQzVNX0IzHhde5FroL2lKL3Cpnf3x+cCShlX
      SxVWFutUxt3ATEFIUFvHhcrrCVeZE9llWeOI99zH1Sijs8CklTlNBPjh4xCbevRX
      KefkdcYW+27/hex9EAziEwKBgCICG0EmewifOiBUAFpA7OWyCxHlqWRCeQWgpp93
      3vvpweooTQUf3y/4V5RDti8L1rAsC5v3FY2InLjOiN/QL711aVWHPnfsueQmoIQV
      ijaoPgGahZnKTLGvCIw/2FXcKcmzG6UROJ7fa8iUEzYnJQz19Q60i1fXEOG+A5B1
      bAqzAoGAdMTTrDnSXZyPvnLE+RVImOBReFf5yjyh0zQ5mPGQe2qZcY2c+oKS/m3B
      OmgYmcPHy86OchpI+cYTUsCr+sMwpKwdnb49VuoDFYOuVsE4vFT/jJs3Bil3bsnc
      uMObnA6Is7MX1EItBTCug8192gu8Mcc6zOVo0TkzbQdEdmms3Gk=
      -----END RSA PRIVATE KEY-----
    poudriere_ports:
      mini:
        method: git
        branch: 20170222
        state: present
      vagrant:
        state: present
        extra_flags: -f none -F
        path: /home/vagrant/freebsd-ports
    poudriere_jails:
      "10_3":
        method: http
        version: 10.3-RELEASE
        state: present
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
