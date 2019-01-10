module Journea
  class EngineController < ::ApplicationController
    helper Journea::Engine.helpers

    protect_from_forgery with: :exception

    before_action :set_view_paths

    private

    def model
      ::Journea::Journey
    end

    def set_view_paths
      prepend_view_path Rails.root.join("app", "views", "steps")
    end
  end
end
