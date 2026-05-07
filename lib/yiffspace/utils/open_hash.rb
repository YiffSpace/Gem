# frozen_string_literal: true

require("active_support/hash_with_indifferent_access")

module YiffSpace
  module Utils
    class OpenHash < ActiveSupport::HashWithIndifferentAccess
      def initialize(constructor = nil, respond_to_missing: true)
        super(constructor)
        @respond_to_missing = respond_to_missing
      end

      def respond_to_missing?(name, include_private = false)
        return true if @respond_to_missing
        name = name.to_s
        key?(name) || name.end_with?("=") || super
      end

      def method_missing(name, *args)
        if name.end_with?("=")
          public_send(:[]=, name.to_s.chomp("=").to_sym, args.first)
        elsif key?(name)
          public_send(:[], name)
        elsif @respond_to_missing
          nil
        else
          super
        end
      end

      def self.from(hash = nil, recursive: true, respond_to_missing: true, **kwargs)
        hash = kwargs if hash.nil? && kwargs.any?
        raise(ArgumentError, "no hash provided") if hash.nil?
        oh = OpenHash.new(respond_to_missing: respond_to_missing)
        hash.each do |key, value|
          if recursive && value.is_a?(Hash)
            oh[key] = OpenHash.from(value, recursive: recursive)
          elsif recursive && value.is_a?(Array)
            oh[key] = value.map { |v| v.is_a?(Hash) ? OpenHash.from(v, recursive: recursive, respond_to_missing: respond_to_missing) : v }
          else
            oh[key] = value
          end
        end
        oh
      end

      def self.from_array(items, **)
        items.map { |item| from(item, **) }
      end
    end
  end
end
