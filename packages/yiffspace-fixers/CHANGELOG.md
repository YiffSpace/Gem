## Unreleased

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
