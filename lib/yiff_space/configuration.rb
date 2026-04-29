# frozen_string_literal: true

module YiffSpace
  class Configuration
    def auth(&block)
      client = YiffSpace::Auth.register(Auth::DEFAULT_CLIENT_NAME) unless YiffSpace::Auth.instance_variable_get(:@clients).key?(Auth::DEFAULT_CLIENT_NAME)
      client ||= YiffSpace::Auth[Auth::DEFAULT_CLIENT_NAME]
      block&.call(client)
      client
    end

    def add_auth(name, &)
      YiffSpace::Auth.register(name, &)
    end

    def images
      @images ||= Images.new
    end
  end
end
