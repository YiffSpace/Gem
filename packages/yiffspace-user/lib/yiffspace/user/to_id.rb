# frozen_string_literal: true

module YiffSpace
  module User
    module ToId
      def u2id(value, klass = YiffSpace.config.user_class)
        value.is_a?(klass) || (klass == YiffSpace.config.user_class && value.is_a?(YiffSpace.config.user_resolvable_class)) ? value.id : value
      end
    end
  end
end
