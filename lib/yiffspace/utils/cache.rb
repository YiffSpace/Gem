# frozen_string_literal: true

module YiffSpace
  module Utils
    module Cache
      module_function

      def read_multi(keys, prefix)
        sanitized_key_to_key_hash = keys.index_by { |key| "#{prefix}:#{key}" }

        sanitized_keys = sanitized_key_to_key_hash.keys
        sanitized_key_to_value_hash = Rails.cache.read_multi(*sanitized_keys)

        sanitized_key_to_value_hash.transform_keys(&sanitized_key_to_key_hash)
      end

      def fetch(key, expires_in: nil, &)
        Rails.cache.fetch(key, expires_in: expires_in, &)
      end

      def write(key, value, expires_in: nil)
        Rails.cache.write(key, value, expires_in: expires_in)
      end

      def delete(key)
        Rails.cache.delete(key)
      end

      def clear
        Rails.cache.clear
      end

      def redis
        # Using a shared variable like this here is OK
        # since pitchfork spawns a new process for each worker
        @redis ||= Redis.new(url: YiffSpace.config.redis_url.call)
      end
    end
  end
end
