# frozen_string_literal: true

begin
  require("yiffspace/user")
  UserResolvable = YiffSpace::User::Resolvable
rescue LoadError
  nil
end
