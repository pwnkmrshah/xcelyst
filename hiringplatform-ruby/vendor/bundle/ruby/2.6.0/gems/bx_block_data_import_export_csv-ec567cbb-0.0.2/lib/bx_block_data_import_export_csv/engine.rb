# frozen_string_literal: true

module BxBlockDataImportExportCsv
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockDataImportExportCsv
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_data_import_export_csv.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockDataImportExportCsv::Engine => base + '/data_import_export_csv'
      end
    end
  end
end
