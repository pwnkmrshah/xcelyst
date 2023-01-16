module BuilderBase
  module App
    # Generators are not easy to test
    # Put as much logic as possible here.
    # The code here should not invoke any templating/file manipulation methods
    # that are only available in the context of a generator.
    module FinalizeGeneratorInstance
      private

      def templates
        [
          ['README.md'],
        ].freeze
      end

      def each_template
        templates.each do |params|
          source = params.first
          dest   = params.first

          yield source, dest
        end
      end
    end
  end
end
