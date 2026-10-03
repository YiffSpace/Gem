## Unreleased

- Fixes run through `YiffSpace::FixTracker.run!` (so every `fixes:*` task) can call
  `requires_migration!` unqualified, via `YiffSpace::Fixers::Script` - each fix is now loaded
  wrapped in its own module including it, rather than straight into the top level, so it isn't
  defined anywhere else in the app. Constants a fix defines now land in that wrapper too, instead
  of on `Object`. `required_migration_for` reads the unqualified form as well.
- Fixed `lib/yiffspace/fixers.rb` never actually defining `YiffSpace::Fixers` -
  it set up the `for_gem_extension` Zeitwerk loader but skipped the namespace
  module the convention requires the root file to define, so referencing
  `YiffSpace::Fixers` (even indirectly, e.g. `YiffSpace::Fixers::Engine`)
  after the gem's initial `require` raised `Zeitwerk::NameError: expected
  file ... to define constant YiffSpace::Fixers, but didn't`.

## 0.0.1

- Initial release, extracted from the `yiffspace` gem's `YiffSpace::FixTracker`/
  `YiffSpace::FixerTemplate`/`YiffSpace::Configuration::FixerTemplates`, the
  `yiffspace:fixer`/`yiffspace:install:fixes` generators, and the `fixes:*`
  rake tasks.
