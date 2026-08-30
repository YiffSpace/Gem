# frozen_string_literal: true

begin
  require("yiffspace/core")
  Routes = YiffSpace::Utils::Routes
rescue LoadError
  nil
end
