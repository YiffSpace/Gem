# frozen_string_literal: true

begin
  require("yiffspace/core")
  ParameterBuilder = YiffSpace::Utils::ParameterBuilder
rescue LoadError
  nil
end
