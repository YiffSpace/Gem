## Unreleased

- **Breaking:** renamed the gem from `yiffspace` to `yiffspace-core`, and split
  it further into standalone gems for complete modularity:
  [`yiffspace-config`](https://github.com/YiffSpace/Gem/tree/master/yiffspace-config)
  (`YiffSpace::ConfigBuilder`),
  [`yiffspace-ext`](https://github.com/YiffSpace/Gem/tree/master/yiffspace-ext)
  (generic Object/Hash/Enumerable/String core extensions + `WhereChain`),
  [`yiffspace-arel`](https://github.com/YiffSpace/Gem/tree/master/yiffspace-arel)
  (Postgres lateral-join/unnest extensions),
  [`yiffspace-images`](https://github.com/YiffSpace/Gem/tree/master/yiffspace-images)
  (avatar/banner URLs),
  [`yiffspace-tables`](https://github.com/YiffSpace/Gem/tree/master/yiffspace-tables)
  (`YiffSpace::Utils::TableBuilder`),
  [`yiffspace-search`](https://github.com/YiffSpace/Gem/tree/master/yiffspace-search)
  (`YiffSpace::Search::*`),
  [`yiffspace-user`](https://github.com/YiffSpace/Gem/tree/master/yiffspace-user)
  (the User/Current/UserResolvable concerns), and
  [`yiffspace-include`](https://github.com/YiffSpace/Gem/tree/master/yiffspace-include)
  (the deprecated global-alias layer). The `yiffspace` gem is now a husk that
  just depends on all of the above, so `gem "yiffspace"` keeps working
  unchanged for apps that want everything; apps that only need a subset can
  depend on the specific gems instead.
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
- Fixed `YiffSpace::Utils::Helpers`/`Routes` (`Helpers`/`Routes` under
  `yiffspace-include`) dropping keyword arguments: their `method_missing` used
  a bare `*, &` splat, which isn't `ruby2_keywords`-aware, so a call like
  `h.some_helper(post, tags: tags)` arrived with the `tags:` hash flattened
  into a positional argument instead of a keyword - silently landing in
  whatever parameter came next rather than raising. Both now use `...` to
  forward positional, keyword, and block arguments correctly.
- `YiffSpace::Utils::Helpers` (`Helpers`) now also makes the app's route
  `_path`/`_url` helpers available *inside* the helper methods it proxies to,
  not just to callers going through it directly - a helper that itself calls
  `some_path(...)` (with no receiver) now works the same way it would from a
  real view, instead of raising `NoMethodError`.

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
