# frozen_string_literal: true

module YiffSpace
  class Configuration
    # Maximum number of comma-separated values allowed in a multi-value query parameter.
    # Used by ParseValue.range and (in yiffspace-search) QueryBuilder.
    attr_reader(:max_multi_count)

    # Redis URL used by Utils::Cache for direct Redis connections.
    attr_reader(:redis_url)

    # The application's ApplicationRecord class. Used by Concerns::ActiveRecordExtensions & (in
    # yiffspace-tables) Utils::TableBuilder.
    # Falls back to ::ApplicationRecord at call time when nil.
    attr_writer(:application_record_class)

    # The application's ApplicationController class. Used by Utils::Helpers & (in
    # yiffspace-tables) Utils::TableBuilder.
    # Falls back to ::ApplicationController at call time when nil.
    attr_writer(:application_controller_class)

    def initialize
      @max_multi_count = -> { 100 }
      @redis_url       = -> {}
    end

    def redis_url=(value)
      @redis_url = value.is_a?(Proc) ? value : -> { value }
    end

    def max_multi_count=(value)
      @max_multi_count = value.is_a?(Proc) ? value : -> { value }
    end

    def application_record_class
      @application_record_class || ::ApplicationRecord
    end

    def application_controller_class
      @application_controller_class || ::ApplicationController
    end
  end
end
