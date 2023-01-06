# frozen_string_literal: true

module BxBlockCalendar
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockCalendar
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_calendar.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockCalendar::Engine => base + '/calendar'
      end
    end
  end
end
