# frozen_string_literal: true

module YiffSpace
  module Auth
    class UserInfo
      attr_reader(:id, :user, :discord, :client_id)

      # @param id String
      # @param user OpenIDConnect::ResponseObject::UserInfo
      # @param discord Hash
      # @param client_id String
      def initialize(id:, user:, discord:, client_id:)
        raise(ArgumentError, "no id provided") if id.blank?
        raise(ArgumentError, "no user provided") if user.blank?

        @id        = id
        @user      = user
        @discord   = DiscordInfo.from_json(discord)
        @client_id = client_id
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

      def avatar(type = nil)
        type.present? ? Images::Avatar.get_for(id, type) : Images::Avatar.default_for(id)
      end

      def avatar_url(type = nil)
        avatar(type).url
      end

      def banner(type = nil)
        type.present? ? Images::Banner.get_for(id, type) : Images::Banner.default_for(id)
      end

      def banner_url(type = nil)
        banner(type).url
      end

      delegate(:username, to: :discord)

      def display_name
        discord.global_name
      end

      def serializable_hash(_options = {})
        {
          "id"      => id,
          "discord" => discord.serializable_hash,
          "user"    => ::YiffSpace::Auth.serialize_user(user, client_id: client_id),
        }
      end

      def to_session
        serializable_hash.without("discord").merge(discord: discord.to_session)
      end

      def self.from_json(data)
        raise(ArgumentError, "invalid data") if data.blank?
        data = JSON.parse(data) if data.is_a?(String)
        data = ::YiffSpace::Utils::OpenHash.from(data)

        user_data = ::YiffSpace::Utils::OpenHash.from(data.user)
        new(
          id:        data.id,
          discord:   data.discord,
          user:      ::YiffSpace::Auth.unserialize_user(user_data),
          client_id: user_data.client_id,
        )
      end

      def self.from_session(data)
        return nil if data.blank?
        from_json(data)
      end
    end
  end
end
