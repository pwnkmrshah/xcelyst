# frozen_string_literal: true

module BxBlockAppointmentManagement
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockAppointmentManagement
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_appointment_management.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockAppointmentManagement::Engine => base + '/appointment_management'
      end
    end
  end
end
