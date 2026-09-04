## Unreleased

- Fixed `lib/yiffspace/tables.rb` never actually defining `YiffSpace::Tables` -
  it set up the `for_gem_extension` Zeitwerk loader but skipped the namespace
  module the convention requires the root file to define, so referencing
  `YiffSpace::Tables` (even indirectly, e.g. `YiffSpace::Tables::Builder`)
  after the gem's initial `require` raised `Zeitwerk::NameError: expected
  file ... to define constant YiffSpace::Tables, but didn't`.

## 0.0.1

- Initial release, extracted from the `yiffspace` gem's `YiffSpace::Tables::Builder`.
