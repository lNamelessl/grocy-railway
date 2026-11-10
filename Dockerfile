# Grocy on Railway — thin wrapper around the official LinuxServer.io image.
#
# Digest-pinned to linuxserver/grocy 4.7.1 (multi-arch manifest, built 2026-11-08).
# To upgrade: get the new multi-arch digest from
#   docker buildx imagetools inspect lscr.io/linuxserver/grocy:4.x.y
# or https://hub.docker.com/r/linuxserver/grocy/tags , replace the digest below,
# and rebuild. After upgrading, visit "/" once — Grocy runs its DB migration there.
# The --platform pin is load-bearing: the multi-arch index also carries an arm64
# variant, and without an explicit platform some builders resolve the wrong one.
FROM --platform=linux/amd64 lscr.io/linuxserver/grocy@sha256:e4e34a0a84f407b1bcd2c3b6cd1999bf99bcad1defa8847adea7dc82a9cd6b8c

# No other changes needed:
# - The LSIO nginx baseimage (alpine-nginx 3.24) serves plain HTTP on port 80 and
#   HTTPS on 443 from the same server block, with NO HTTP->HTTPS redirect, so
#   Railway's TLS termination + targetPort 80 works out of the box.
# - All persistent state (SQLite grocy.db, config.php, plugins, viewcache) lives
#   under /config/data — attach a Railway volume at /config.
# - First login: admin / admin (change it immediately in user settings).
