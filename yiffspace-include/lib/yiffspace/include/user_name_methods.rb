# frozen_string_literal: true

begin
  require("yiffspace/user")
  UserNameMethods = YiffSpace::Concerns::UserNameMethods
rescue LoadError
  nil
end
