require_relative './concerns/finalize_generator_instance'

module BuilderBase
  module App
    # These are not easy to test.
    # Put as much logic as possible in mixins.
    # The mixins should not call any templating/file manipulation methods.
    class FinalizeGenerator < Rails::Generators::Base
      include FinalizeGeneratorInstance

      source_root File.expand_path('templates', __dir__)

      def execute
        each_template do |source, dest|
          template source, dest
        end
      end
    end
  end
end
