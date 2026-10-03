# frozen_string_literal: true

module YiffSpace
  module Fixers
    # Helpers available unqualified at the top level of a db/fixes/*.rb script when it's run
    # through YiffSpace::FixTracker.run! - the script is loaded wrapped in a module including
    # this, so they never leak onto Object for the rest of the app.
    module Script
      delegate(:requires_migration!, to: "YiffSpace::FixTracker")
    end
  end
end
