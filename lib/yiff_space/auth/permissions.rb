# frozen_string_literal: true

module YiffSpace
  module Auth
    class Permissions
      attr_accessor(:values)

      delegate(:each, to: :values)

      include(Enumerable)

      def initialize(perms)
        @values = perms
        @tree   = {}

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

      def each(&)
        return enum_for(:each) unless block_given?
        @values.each(&)
      end

      def self.new_from_subtree(tree)
        obj = allocate
        obj.instance_variable_set(:@tree, tree)
        obj.instance_variable_set(:@values, leaves_from_tree(tree))
        obj
      end

      def self.leaves_from_tree(node, prefix = "")
        result = []
        node.each do |key, subtree|
          next if key == :__leaf__
          path = prefix.empty? ? key : "#{prefix}.#{key}"
          result << path if subtree[:__leaf__]
          result.concat(leaves_from_tree(subtree, path))
        end
        result
      end
    end
  end
end
