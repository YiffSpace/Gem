# frozen_string_literal: true

module YiffSpace
  module Auth
    class Client
      attr_accessor(:client_name, :client_id, :client_secret, :redirect_uri,
                    :server_url, :scopes, :auth_session_key, :user_session_key,
                    :token_session_key, :return_path_session_key, :state_session_key,
                    :state_generator, :after_auth_action, :after_logout_action,
                    :update_discord_images)

      attr_reader(:name)

      def initialize(name)
        @name                    = name.to_sym
        @server_url              = "https://auth.yiff.space"
        @redirect_uri            = "http://127.0.0.1:3000/auth/cb"
        @scopes                  = %i[openid discord offline_access entitlements]
        @auth_session_key        = :"yiffspace_auth_#{name}"
        @user_session_key        = :"yiffspace_user_#{name}"
        @token_session_key       = :"yiffspace_token_#{name}"
        @return_path_session_key = :"yiffspace_return_path_#{name}"
        @state_session_key       = :"yiffspace_state_#{name}"
        @state_generator         = -> { SecureRandom.hex(48) }
        @update_discord_images   = true
      end

      def openid_config
        @openid_config ||= OpenIDConnect::Discovery::Provider::Config.discover!("#{server_url}/application/o/#{client_name}/")
      end

      def oidc_client
        @oidc_client ||= OpenIDConnect::Client.new(
          identifier:             client_id,
          secret:                 client_secret,
          redirect_uri:           redirect_uri,
          authorization_endpoint: openid_config.authorization_endpoint,
          token_endpoint:         openid_config.token_endpoint,
          userinfo_endpoint:      openid_config.userinfo_endpoint,
        )
      end

      def url(state: nil)
        oidc_client.authorization_uri(scope: scopes, state: state)
      end

      def exchange(code)
        oidc_client.authorization_code = code
        token                          = oidc_client.access_token!
        user                           = token.userinfo!
        id                             = user.raw_attributes["discord"]["id"]
        authinfo                       = AuthInfo.new(token: token, entitlements: user.raw_attributes["entitlements"], roles: user.raw_attributes["roles"], id: id)
        userinfo                       = UserInfo.new(user: user, id: id, discord: user.raw_attributes["discord"], client_id: oidc_client.identifier)
        Auth::ExchangeResponse.new(authinfo, userinfo)
      end
    end
  end
end
