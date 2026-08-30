# frozen_string_literal: true

begin
  require("yiffspace/user")
  Current = YiffSpace::User::Current
rescue LoadError
  nil
end
