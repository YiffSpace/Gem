## Unreleased

- Fixed `lib/yiffspace/user.rb` never actually defining `YiffSpace::User` -
  it set up the `for_gem_extension` Zeitwerk loader but skipped the namespace
  module the convention requires the root file to define, so referencing
  `YiffSpace::User` (even indirectly, e.g. `YiffSpace::User::Current`) after
  the gem's initial `require` raised `Zeitwerk::NameError: expected file ...
  to define constant YiffSpace::User, but didn't`.

## 0.0.1

- Initial release, extracted from the `yiffspace` gem's User/Current/Resolvable
  concerns and utils. `YiffSpace::Utils::Current`/`UserLike`/`UserResolvable`/
  `UserAttribute`/`UserToId` are now `YiffSpace::User::Current`/`Like`/
  `Resolvable`/`Attribute`/`ToId`.
