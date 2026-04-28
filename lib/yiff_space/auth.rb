# frozen_string_literal: true

require("openid_connect")

module YiffSpace
  module Auth
    class SerializeError < StandardError; end

    module_function

    def openid_config
      @openid_config ||= OpenIDConnect::Discovery::Provider::Config.discover!("#{YiffSpace.config.auth.server_url}/application/o/#{YiffSpace.config.auth.client_name}/")
    end

    def client
      @client ||= OpenIDConnect::Client.new(
        identifier:             YiffSpace.config.auth.client_id,
        secret:                 YiffSpace.config.auth.client_secret,
        redirect_uri:           YiffSpace.config.auth.redirect_uri,
        authorization_endpoint: openid_config.authorization_endpoint,
        token_endpoint:         openid_config.token_endpoint,
        userinfo_endpoint:      openid_config.userinfo_endpoint,
      )
    end

    def url(state: nil)
      client.authorization_uri(
        scope: YiffSpace.config.auth.scopes,
        state: state,
      )
    end

    ExchangeResponse = Struct.new(:auth, :user)

    def exchange(code)
      client.authorization_code = code
      token                     = client.access_token!
      user                      = token.userinfo!
      id                        = user.raw_attributes["discord"]["id"]
      authinfo                  = AuthInfo.new(token: token, entitlements: user.raw_attributes["entitlements"], roles: user.raw_attributes["roles"], id: id)
      userinfo                  = UserInfo.new(user: user, id: id, discord: user.raw_attributes["discord"])
      ExchangeResponse.new(authinfo, userinfo)
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
      if client.identifier != data.client_id
        raise(SerializeError, "current client does not match token's client, refusing to reconstruct")
      end

      OpenIDConnect::AccessToken.new(data.attributes.merge(client: client))
    end

    def serialize_user(user, client_id:)
      { attributes: user.raw_attributes, client_id: client_id }
    end

    def unserialize_user(data)
      raise(SerializeError, "no user data provided") if data.blank?
      return data if data.is_a?(OpenIDConnect::ResponseObject::UserInfo)
      data = JSON.parse(data) if data.is_a?(String)
      data = ::YiffSpace::Utils::OpenHash.from(data)
      raise(SerializeError, "no client id for token, refusing to reconstruct") if data.client_id.nil?
      if client.identifier != data.client_id
        raise(SerializeError, "current client does not match token's client, refusing to reconstruct")
      end

      OpenIDConnect::ResponseObject::UserInfo.new(data.attributes)
    end
  end
end
