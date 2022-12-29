# frozen_string_literal: true

module BuilderBase
  class Engine < ::Rails::Engine
    isolate_namespace BuilderBase
    config.generators.api_only = true
  end
end
