# frozen_string_literal: true

require("abbrev")

module YiffSpace
  module Utils
    module DurationParser
      def self.parse(string)
        abbrevs = Abbrev.abbrev(%w[seconds minutes hours days weeks months years])

        raise unless string =~ /(.*?)([a-z]+)\z/i

        size = Float($1)
        unit = abbrevs.fetch($2.downcase)

        raise(NotImplementedError) unless %w[seconds minutes hours days weeks months years].include?(unit)

        size.public_send(unit)
      rescue # rubocop:disable Style/RescueStandardError
        raise(ArgumentError, "'#{string}' is not a valid duration")
      end
    end
  end
end
