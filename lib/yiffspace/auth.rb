# frozen_string_literal: true

module YiffSpace
  module Auth
    CLIENT_NAME_ENV     = "yiffspace.auth.client_name"
    DEFAULT_CLIENT_NAME = :default

    @clients             = {}
    @enable_debug_action = false

    module_function

    def register(name, &block)
      client = Client.new(name)
      block&.call(client)
      @clients[name.to_sym] = client
      client
    end

    def [](name)
      @clients[name.to_sym] || raise(KeyError, "unknown auth client: #{name.inspect}")
    end

    def default
      @clients[DEFAULT_CLIENT_NAME] || raise("no default client configured")
    end

    def get_by_id(id)
      @clients.values.find { |c| c.client_id == id } || raise(ArgumentError, "unable to find client with id: #{id}")
    end

    def enable_debug_action?
      @enable_debug_action
    end

    def enable_debug_action!
      @enable_debug_action = true
    end

    def disable_debug_action!
      @enable_debug_action = false
    end
  end
end
