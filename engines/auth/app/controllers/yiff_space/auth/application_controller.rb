# frozen_string_literal: true

module YiffSpace
  module Auth
    class ApplicationController < ::YiffSpace::ApplicationController
      include(SessionHelper)

      helper(SessionHelper)
    end
  end
end
