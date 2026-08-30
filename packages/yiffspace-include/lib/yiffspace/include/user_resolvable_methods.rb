# frozen_string_literal: true

begin
  require("yiffspace/user")
  UserResolvableMethods = YiffSpace::Concerns::UserResolvableMethods
rescue LoadError
  nil
end
