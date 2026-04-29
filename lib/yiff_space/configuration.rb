# frozen_string_literal: true

module YiffSpace
  class Configuration
    def auth(&block)
      client = YiffSpace::Auth.register(:default) unless YiffSpace::Auth.instance_variable_get(:@clients).key?(:default)
      client ||= YiffSpace::Auth[:default]
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
