## 0.0.1

- Initial release, extracted from the `yiffspace` gem's `include/` global-alias
  layer. Each alias now requires the gem that owns the real class (e.g.
  `yiffspace-tables` for `TableBuilder`) and no-ops if it isn't installed,
  instead of assuming everything lives in one gem.
