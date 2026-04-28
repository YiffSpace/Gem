# frozen_string_literal: true

module YiffSpace
  module Auth
    class Permissions
      def initialize(perms)
        @tree = {}

        perms.each do |perm|
          current = @tree
          parts   = perm.split(".")

          parts.each do |part|
            current[part] ||= {}
            current       = current[part]
          end

          # mark leaf
          current[:__leaf__] = true
        end
      end

      def has?(perm)
        current = @tree
        parts   = perm.split(".")

        parts.each do |part|
          return false unless current[part]
          current = current[part]
        end

        current[:__leaf__] == true
      end

      alias include? has?

      def method_missing(name, *_args)
        str = name.to_s

        if str.end_with?("?")
          key = str[0..-2]
          return @tree[key]&.dig(:__leaf__) == true
        end

        if @tree.key?(str)
          self.class.new_from_subtree(@tree[str])
        else
          # return empty node instead of raising
          self.class.new([])
        end
      end

      def respond_to_missing?(_name, _include_private = false)
        true
      end

      def self.new_from_subtree(tree)
        obj = allocate
        obj.instance_variable_set(:@tree, tree)
        obj
      end
    end
  end
end
