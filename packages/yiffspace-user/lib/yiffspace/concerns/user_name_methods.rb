# frozen_string_literal: true

module YiffSpace
  module Concerns
    module UserNameMethods
      extend(ActiveSupport::Concern)

      module ClassMethods
        def name_to_id(name)
          normalized_name = normalize_name(name)
          Utils::Cache.fetch("uni:#{normalized_name}", expires_in: 4.hours) do
            ::User.where("lower(name) = ?", normalized_name).pick(:id)
          end
        end

        # @param arguments [Array<String, Array<String>>] a list of names
        # @return [Hash{String => Integer, nil}] a hash of normalized names to user IDs
        def bulk_name_to_id(*arguments)
          names = arguments.flatten.map { |n| normalize_name(n) }
          results = names.index_with { |name| Utils::Cache.fetch("uni:#{name}") }.compact_blank
          missing = names - results.keys
          fetched = ::User.where("lower(name) IN (?)", missing).select(:id, :name).to_h { |u| [normalize_name(u.name), u.id] }
          not_found = (missing - fetched.keys).index_with { nil }
          fetched.each { |name, id| Utils::Cache.write("uni:#{name}", id, expires_in: 4.hours) }
          { **results, **fetched, **not_found }
        end

        def name_or_id_to_id(name)
          return name[1..].to_i if name =~ /\A!\d+\z/

          ::User.name_to_id(name)
        end

        def name_or_id_to_id_forced(name)
          return name.to_i if name =~ /\A\d+\z/

          ::User.name_to_id(name)
        end

        def id_to_name(user_id)
          RequestStore[:id_name_cache] ||= {}
          return RequestStore[:id_name_cache][user_id] if RequestStore[:id_name_cache].key?(user_id)

          name = Utils::Cache.fetch("uin:#{user_id}", expires_in: 4.hours) do
            ::User.where(id: user_id).pick(:name) || YiffSpace.config.anonymous_user_name.call
          end
          RequestStore[:id_name_cache][user_id] = name
          name
        end
      end
    end
  end
end
