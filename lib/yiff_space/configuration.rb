# frozen_string_literal: true

module YiffSpace
  class Configuration
    def auth
      @auth ||= Auth.new
    end

    def images
      @images ||= Images.new
    end
  end
end
