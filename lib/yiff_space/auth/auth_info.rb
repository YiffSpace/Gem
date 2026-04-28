# frozen_string_literal: true

module YiffSpace
  module Auth
    class AuthInfo
      attr_reader(:id, :token, :entitlements, :roles, :permissions)

      # @param id String
      # @param roles Array(String)
      # @param entitlements Array(String)
      # @param token OpenIDConnect::AccessToken
      def initialize(id:, entitlements:, roles:, token:)
        raise(ArgumentError, "no id provided") if id.blank?
        raise(ArgumentError, "no token provided") if token.blank?
        @id           = id
        @token        = token
        @entitlements = Array(entitlements)
        @roles        = Array(roles)
        @permissions  = Permissions.new(@entitlements)
      end

      def anonymous?
        false
      end

      # this feels wrong, but it hopefully shouldn't break anything
      def present?
        true
      end

      def blank?
        false
      end

      def has_permission?(name)
        permissions.include?(name.to_s)
      end

      def serializable_hash(*)
        {
          "id"           => id,
          "token"        => ::YiffSpace::Auth.serialize_token(token),
          "entitlements" => entitlements,
          "roles"        => roles,
        }
      end

      def to_session
        serializable_hash
      end

      def self.from_json(data)
        raise(ArgumentError, "invalid data") if data.blank?
        data = JSON.parse(data) if data.is_a?(String)
        data = ::YiffSpace::Utils::OpenHash.from(data)

        new(
          id:           data.id,
          token:        ::YiffSpace::Auth.unserialize_token(data.token),
          entitlements: data.entitlements,
          roles:        data.roles,
        )
      end

      def self.from_session(data)
        return nil if data.blank?
        from_json(data)
      end
    end
  end
end
