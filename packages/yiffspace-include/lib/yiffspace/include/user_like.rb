# frozen_string_literal: true

begin
  require("yiffspace/user")
  UserLike = YiffSpace::User::Like
rescue LoadError
  nil
end
