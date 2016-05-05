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
| poudriere\_ATOMIC\_PACKAGE\_REPOSITORY | | yes |
| poudriere\_BASEFS | | /usr/local/poudriere |
| poudriere\_BUILD\_AS\_NON\_ROOT | see /usr/local/etc/poudriere.conf.sample | yes |
| poudriere\_CHECK\_CHANGED\_DEPS | | true |
| poudriere\_CHECK\_CHANGED\_OPTIONS | | verbose |
| poudriere\_DISTFILES\_CACHE | | /usr/ports/distfiles |
| poudriere\_FREEBSD\_HOST | | ftp://ftp.FreeBSD.org |
| poudriere\_FTP\_PROXY | | "" |
| poudriere\_GIT\_URL | | "" |
| poudriere\_HTTP\_PROXY | | "" |
| poudriere\_NO\_PROXY | | localhost,127.0.0.1 |
| poudriere\_NO\_ZFS | | yes |
| poudriere\_POUDRIERE\_DATA | | ${BASEFS}/data |
| poudriere\_RESOLV\_CONF | | /etc/resolv.conf |
| poudriere\_SVN\_HOST | | svn0.us-west.FreeBSD.org |
| poudriere\_TMPFS\_LIMIT | | 8 |
| poudriere\_USE\_PORTLINT | | no |
| poudriere\_USE\_TMPFS | | no |
| poudriere\_WRKDIR\_ARCHIVE\_FORMAT | | tbz |

Dependencies
------------

None

Example Playbook
----------------

    - hosts: all
      roles:
        - ansible-role-poudriere
      vars:
        poudriere_NO_ZFS: "yes"
        poudriere_GIT_URL: "https://github.com/freebsd/freebsd-ports.git"
        poudriere_FREEBSD_HOST: "ftp://ftp.jp.freebsd.org"

License
-------

BSD

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
