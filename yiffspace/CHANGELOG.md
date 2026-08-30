## Unreleased

- **Breaking:** extracted the one-time db/fixes system (`YiffSpace::FixTracker`,
  `YiffSpace::FixerTemplate`, `YiffSpace::Configuration::FixerTemplates`, the
  `yiffspace:fixer`/`yiffspace:install:fixes` generators, and the `fixes:*`
  rake tasks) into a separate gem,
  [`yiffspace-fixers`](https://github.com/YiffSpace/Gem/tree/master/yiffspace-fixers).
  Apps using the fixes system need to add that gem alongside `yiffspace`.
- `YiffSpace::Configuration#fixer_templates`/`#fixer_templates_path` moved to
  `yiffspace-fixers`.
- The dummy test app no longer needs Postgres - only the fixes table's
  `nulls_not_distinct` index required it, and that lives in `yiffspace-fixers`
  now. Back to plain sqlite3, `docker-compose.yml` removed.

## 0.1.0

- **Breaking:** extracted the Logto auth engine (`YiffSpace::Auth::*`) into a
  separate gem, [`yiffspace-auth`](https://github.com/YiffSpace/Auth.rb). Apps
  using auth need to add that gem alongside `yiffspace`.
- `YiffSpace::Configuration#auth`/`#add_auth`/`#add_default_auth` and the
  `logto_api_*`/`discord_bot_token` settings moved to `yiffspace-auth`.
- Replaced the dead `YiffSpace::Railtie` with a real `YiffSpace::Engine <
  Rails::Engine`, so the shared `app/` directory (ApplicationController,
  layout, error view, CSS, ActiveJob serializers) actually loads into host
  apps again.
