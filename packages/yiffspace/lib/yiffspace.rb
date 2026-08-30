# frozen_string_literal: true

# A husk that just depends on every yiffspace-* gem, for apps that want everything instead of
# picking specific gems. See each gem's own README for what it provides:
#
#   yiffspace-core     - Rails engine, Configuration, shared concerns/utils
#   yiffspace-config   - standalone ConfigBuilder
#   yiffspace-ext      - generic core extensions + WhereChain
#   yiffspace-arel     - Postgres lateral-join/unnest extensions
#   yiffspace-images   - avatar/banner URLs
#   yiffspace-tables   - HTML table-building DSL
#   yiffspace-search   - query-param search DSL
#   yiffspace-user     - User/Current/Resolvable concerns
#   yiffspace-include  - deprecated global-constant aliases
#   yiffspace-auth     - Logto-based auth engine
#   yiffspace-fixers   - one-time db/fixes scripts

require("yiffspace/config")
require("yiffspace/core")
require("yiffspace/ext")
require("yiffspace/arel")
require("yiffspace/images")
require("yiffspace/tables")
require("yiffspace/user")
require("yiffspace/search")
require("yiffspace/include")
require("yiffspace/auth")
require("yiffspace/fixers")
require_relative("yiffspace/version")
