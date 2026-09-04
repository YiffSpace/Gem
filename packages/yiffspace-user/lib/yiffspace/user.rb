# frozen_string_literal: true

require("yiffspace/core")
require("zeitwerk")

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.ignore("#{__dir__}/user/engine.rb")
loader.setup

# Require the engine eagerly so it registers with Rails before the host app's
# active_support.initialize_per_engine_zeitwerk_loaders initializer runs.
require_relative("user/engine") if defined?(Rails)

module YiffSpace
  module User
  end

  class Configuration
    # The application's User model class. Used by User::Current, Search::QueryDSL, etc.
    # Falls back to ::User at call time when nil.
    attr_writer(:user_class)

    # The application's User model class. Used by User::Resolvable
    # Falls back to ::UserLike at call time when nil.
    attr_writer(:user_like_class)

    # The application's UserResolvable class. Used by User::Current.
    # Falls back to ::UserResolvable at call time when nil.
    attr_writer(:user_resolvable_class)

    # The CurrentAttributes class used to access the current user in model concerns.
    # Defaults to YiffSpace::User::Current.
    attr_writer(:current_class)

    # The default IP address assigned to User::Current when none is present.
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

    def user_class
      @user_class || ::User
    end

    def user_like_class
      @user_like_class || User::Like
    end

    def user_resolvable_class
      @user_resolvable_class || User::Resolvable
    end

    # Returns the configured current class, defaulting to YiffSpace::User::Current.
    def current_class
      @current_class || User::Current
    end

    # Lazily built: calls user_class (or ::User) at invocation time, not config time.
    def anonymous_user_getter
      @anonymous_user_getter ||= -> { user_class.anonymous }
    end

    # Lazily built: calls user_class (or ::User) at invocation time, not config time.
    def system_user_getter
      @system_user_getter ||= -> { user_class.system }
    end

    def anonymous_user_name=(value)
      @anonymous_user_name = value.is_a?(Proc) ? value : -> { value }
    end
  end
end

YiffSpace.configure do |config|
  config.default_ip_address     = "127.0.0.1"
  config.last_ip_addr_attribute = :last_ip_addr
  config.anonymous_user_name    = "Anonymous"
end
