# frozen_string_literal: true

begin
  require("yiffspace/user")
  include(YiffSpace::User::ToId)
rescue LoadError
  nil
end
