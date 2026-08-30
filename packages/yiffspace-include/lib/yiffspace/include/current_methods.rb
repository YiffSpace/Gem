# frozen_string_literal: true

begin
  require("yiffspace/user")
  CurrentMethods = YiffSpace::Concerns::CurrentMethods
rescue LoadError
  nil
end
