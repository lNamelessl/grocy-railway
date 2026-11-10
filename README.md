# Grocy on Railway

One-click [Grocy](https://grocy.info/) — the self-hosted household ERP (grocery stock, shopping list, recipes, chores, batteries, tasks) — packaged for [Railway](https://railway.app).

## First login

**Default credentials: `admin` / `admin`. Change the password immediately** (top-right user menu → Users → admin → edit). The instance is exposed on the public internet, so this is not optional.

## What gets deployed

- One service from the digest-pinned `linuxserver/grocy` image (Grocy 4.7.1) — no other changes to the official image.
- One volume mounted at `/config` — this holds the entire state: the SQLite database (`grocy.db`), `config.php`, plugins, and cache. Attach nothing else; nothing to configure.
- Domain routed to the container's port 80 (Railway terminates TLS in front).

## Zero required variables

Grocy works out of the box. Optional variables you may set later (Grocy reads any `GROCY_*` env var as an override, e.g. `GROCY_CURRENCY=EUR`):

| Variable | Purpose |
|---|---|
| `TZ` | Timezone (LSIO convention, e.g. `Europe/Berlin`) |
| `PUID` / `PGID` | Runtime UID/GID of the `abc` user (defaults 1000/1000) |
| `GROCY_AUTH_CLASS` | `Grocy\Middleware\Auth\LdapAuthMiddleware` for LDAP sign-in (plus `GROCY_LDAP_ADDRESS`, `GROCY_LDAP_BASE_DN`, `GROCY_LDAP_BIND_DN`, `GROCY_LDAP_BIND_PW`, `GROCY_LDAP_USER_FILTER`, `GROCY_LDAP_UID_ATTR`) |
| `GROCY_FEATURE_FLAG_CHORES` | Set `false` to hide modules you don't use (same pattern for `STOCK`, `SHOPPINGLIST`, `RECIPES`, `BATTERIES`, `TASKS`, `CALENDAR`, `MEALPLAN`…) |

## Notes

- **Image upgrades**: the Dockerfile pins the image digest. To upgrade Grocy, bump the digest in the Dockerfile to a newer `linuxserver/grocy` tag, redeploy, then **visit `/` once** — Grocy runs its database migration there.
- **No Railway healthcheck by design**: Railway's health probe targets the service's `PORT` variable, but this image ignores the injected `PORT` — nginx listens on fixed port 80 internally (the domain is pinned to that port). With no `PORT` variable the probe could never reach the app, so the template ships without one; deployments go active when the container starts. For reference: `/login` answers 200 without authentication, while `/` redirects (and triggers the first-run DB migration on a fresh volume).
- Railway injects `PORT` but this image does not use it: nginx listens on fixed port 80 internally, and the domain targets that port.
