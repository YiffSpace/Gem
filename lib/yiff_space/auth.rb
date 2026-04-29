# frozen_string_literal: true

require("openid_connect")

module YiffSpace
  module Auth
    class SerializeError < StandardError; end

    ExchangeResponse    = Struct.new(:auth, :user)
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
      @clients[name.to_sym] or raise(KeyError, "unknown auth client: #{name.inspect}")
    end

    def default
      @clients[DEFAULT_CLIENT_NAME] || raise("no default client configured")
    end

    def find_by_client_id(client_id)
      @clients.values.find { |c| c.oidc_client.identifier == client_id }
    end

    def serialize_token(token)
      { attributes: token.raw_attributes.without("client"), client_id: token.client.identifier }
    end

    def unserialize_token(data)
      raise(SerializeError, "no token data provided") if data.blank?
      return data if data.is_a?(OpenIDConnect::AccessToken)
      data = JSON.parse(data) if data.is_a?(String)
      data = ::YiffSpace::Utils::OpenHash.from(data)
      raise(SerializeError, "no client id for token, refusing to reconstruct") if data.client_id.nil?

      client_config = find_by_client_id(data.client_id)
      raise(SerializeError, "unknown client_id #{data.client_id.inspect}") unless client_config

      OpenIDConnect::AccessToken.new(data.attributes.merge(client: client_config.oidc_client))
    end

    def serialize_user(user, client_id:)
      { attributes: user.raw_attributes, client_id: client_id }
    end

    def unserialize_user(data)
      raise(SerializeError, "no user data provided") if data.blank?
      return data if data.is_a?(OpenIDConnect::ResponseObject::UserInfo)
      data = JSON.parse(data) if data.is_a?(String)
      data = ::YiffSpace::Utils::OpenHash.from(data)
      raise(SerializeError, "no client id for user, refusing to reconstruct") if data.client_id.nil?

      find_by_client_id(data.client_id) or raise(SerializeError, "unknown client_id #{data.client_id.inspect}")

      OpenIDConnect::ResponseObject::UserInfo.new(data.attributes)
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
