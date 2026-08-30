# frozen_string_literal: true

begin
  require("yiffspace/user")
  UserMethods = YiffSpace::Concerns::UserMethods
rescue LoadError
  nil
end
