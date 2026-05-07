# frozen_string_literal: true

module YiffSpace
  module Images
    module Banner
      module_function

      def default_for(id)
        type = YiffSpace.config.images.default_banner_type
        get_for(id, type)
      end

      def get_for(id, type)
        klass = find_type(type)
        raise(StandardError, "No banner class for type: #{type}") if klass.nil?
        klass.new(id)
      end

      def find_type(type)
        constants.map { |c| [c, const_get(c)] }.find do |_const, value|
          next unless value < Base
          value.try(:type)&.to_sym == type.to_sym
        end&.second
      end
    end
  end
end
