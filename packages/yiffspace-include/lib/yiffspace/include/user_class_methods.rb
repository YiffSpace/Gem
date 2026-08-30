# frozen_string_literal: true

begin
  require("yiffspace/user")
  UserClassMethods = YiffSpace::Concerns::UserClassMethods
rescue LoadError
  nil
end
