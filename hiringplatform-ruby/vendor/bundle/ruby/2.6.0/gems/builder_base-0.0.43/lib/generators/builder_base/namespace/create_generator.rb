require_relative './concerns/create_generator_instance'

module BuilderBase
  module Namespace
    # These are not easy to test.
    # Put as much logic as possible in mixins.
    # The mixins should not call any templating/file manipulation methods.
    class CreateGenerator < Rails::Generators::NamedBase
      include CreateGeneratorInstance

      source_root File.expand_path('templates', __dir__)

      def execute
        each_namespaced_template do |source, dest|
          template source, dest
        end
      end
    end
  end
end
