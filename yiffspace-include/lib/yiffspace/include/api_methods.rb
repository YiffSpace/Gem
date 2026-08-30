# frozen_string_literal: true

begin
  require("yiffspace/core")
  ApiMethods = YiffSpace::Concerns::ApiMethods
rescue LoadError
  nil
end
