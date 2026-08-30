# frozen_string_literal: true

begin
  require("yiffspace/user")
  UserAttribute = YiffSpace::User::Attribute
rescue LoadError
  nil
end
