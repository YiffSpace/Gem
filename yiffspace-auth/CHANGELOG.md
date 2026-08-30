## 0.0.5

- Add auth spoofing: `YiffSpace::Auth.enable_spoof_auth!`/`disable_spoof_auth!`
  toggle a global switch, and setting `spoof_user_id` (plus optional
  `spoof_permissions`/`spoof_roles`) on a `Client` makes every request through
  that client log in as that user via `Helper#auth`/`#user`, without touching
  the real session. Intended for local development - the gem doesn't gate this
  by environment itself, so only call `enable_spoof_auth!` from somewhere the
  host app already restricts to development (see `enable_debug_action!`).
  Controllers can override this per-request: the `disable_spoof_auth`/
  `override_spoof_auth` class macros (and the underlying `spoof_override=`
  setter, for values only known at request time) let a controller opt out of
  spoofing entirely, or swap in its own `spoof_user_id`/`spoof_permissions`/
  `spoof_roles` independent of the client's configured defaults.

## 0.0.1

- Initial release, extracted from the `yiffspace` gem's `YiffSpace::Auth::*`
  engine.
