# frozen_string_literal: true

module YiffSpace
  class Configuration
    # Maximum number of comma-separated values allowed in a multi-value query parameter.
    # Used by ParseValue.range and QueryBuilder.
    attr_reader(:max_multi_count)

    # Redis URL used by Utils::Cache for direct Redis connections.
    attr_reader(:redis_url)

    # The application's User model class. Used by Utils::Current, Search::QueryDSL, etc.
    # Falls back to ::User at call time when nil.
    attr_writer(:user_class)

    # The application's User model class. Used by Utils::UserResolvable
    # Falls back to ::UserLike at call time when nil.
    attr_writer(:user_like_class)

    # The application's UserResolvable class. Used by Utils::Current.
    # Falls back to ::UserResolvable at call time when nil.
    attr_writer(:user_resolvable_class)

    # The CurrentAttributes class used to access the current user in model concerns.
    # Defaults to YiffSpace::Utils::Current.
    attr_writer(:current_class)

    # The default IP address assigned to Utils::Current when none is present.
    attr_accessor(:default_ip_address)

    # The `last_ip_addr` attribute of the User model, used by the UserResolvableMethods concern
    attr_accessor(:last_ip_addr_attribute)

    # The anonymous user's name, can be a proc
    attr_reader(:anonymous_user_name)

    # Override the proc used to fetch the anonymous user. Must respond to #call.
    # Default: -> { (user_class || ::User).anonymous }
    attr_writer(:anonymous_user_getter)

    # Override the proc used to fetch the system user. Must respond to #call.
    # Default: -> { (user_class || ::User).system }
    attr_writer(:system_user_getter)

    def initialize
      @max_multi_count         = -> { 100 }
      @redis_url               = -> {}
      @user_class              = nil
      @user_like_class         = nil
      @user_resolvable_class   = nil
      @current_class           = nil
      @default_ip_address      = "127.0.0.1"
      @last_ip_addr_attribute  = :last_ip_addr
      @anonymous_user_name     = -> { "Anonymous" }
    end

    def user_class
      @user_class || ::User
    end

    def user_like_class
      @user_like_class || Utils::UserLike
    end

    def user_resolvable_class
      @user_resolvable_class || Utils::UserResolvable
    end

    # Returns the configured current class, defaulting to YiffSpace::Utils::Current.
    def current_class
      @current_class || Utils::Current
    end

    # Lazily built: calls user_class (or ::User) at invocation time, not config time.
    def anonymous_user_getter
      @anonymous_user_getter ||= -> { user_class.anonymous }
    end

    # Lazily built: calls user_class (or ::User) at invocation time, not config time.
    def system_user_getter
      @system_user_getter ||= -> { user_class.system }
    end

    def redis_url=(value)
      @redis_url = value.is_a?(Proc) ? value : -> { value }
    end

    def max_multi_count=(value)
      @max_multi_count = value.is_a?(Proc) ? value : -> { value }
    end

    def anonymous_user_name=(value)
      @anonymous_user_name = value.is_a?(Proc) ? value : -> { value }
    end

    def images
      @images ||= Images.new
    end
  end
end
