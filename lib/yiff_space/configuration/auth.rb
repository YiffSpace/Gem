# frozen_string_literal: true

module YiffSpace
  class Configuration
    class Auth
      attr_accessor(:client_name, :client_id, :client_secret, :redirect_uri,
                    :server_url, :scopes, :auth_session_key, :user_session_key,
                    :token_session_key, :return_path_session_key, :state_session_key, :state_generator,
                    :after_auth_action, :after_logout_action, :update_discord_images)

      def initialize
        @server_url              = "https://auth.yiff.space"
        @redirect_uri            = "http://127.0.0.1:3000/auth/cb"
        @scopes                  = %i[openid discord offline_access entitlements]
        @auth_session_key        = :yiffspace_auth
        @user_session_key        = :yiffspace_user
        @token_session_key       = :yiffspace_token
        @return_path_session_key = :yiffspace_return_path
        @state_session_key       = :yiffspace_state
        @state_generator         = -> { SecureRandom.hex(48) }
        @update_discord_images   = true
      end
    end
  end
end
