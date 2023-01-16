module BuilderBase
  module Namespace
    # Generators are not easy to test
    # Put as much logic as possible here.
    # The code here should not invoke any templating/file manipulation methods
    # that are only available in the context of a generator.
    module CreateGeneratorInstance
      private

      def name=(value)
        @name = super
          .gsub(/[^\w]+/, '_')
          .downcase
      end

      def folder
        @folder ||= "bx_block_#{name.underscore}"
      end

      def namespace
        @namespace ||= folder.camelcase
      end

      def namespaced_templates
        [
          ['application_controller.rb.erb', :controllers],
          ['application_record.rb.erb',     :models],
          ['application_job.rb.erb',        :jobs],
          ['application_mailer.rb.erb',     :mailers],
        ].freeze
      end

      def each_namespaced_template
        namespaced_templates.each do |params|
          source, type_name = params

          file = source

          file = file.gsub(File.extname(source), '') if file.match(/\.erb$/)

          dest = File.join('app', type_name.to_s, folder, file)

          yield source, dest
        end
      end
    end
  end
end
