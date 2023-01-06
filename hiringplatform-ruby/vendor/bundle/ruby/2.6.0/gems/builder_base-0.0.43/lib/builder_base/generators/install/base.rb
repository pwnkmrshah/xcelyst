module BuilderBase
  module Generators
    module Install
      class Base < Rails::Generators::Base
        class << self
          def generator_root
            return @generator_root if defined?(@generator_root)
            raise "generator_root has not been set for #{self}"
          end

          private

          def set_file_directory(path)
            # we capture everything before lib, that should be our root
            @generator_root = path.match(/(.*)lib.*/)[1]
          end
        end

        set_file_directory __dir__

        def execute
          paths.each do |path|
            base = File.join(generator_root, path)
            rb_files = Array(Dir[File.join(base, '**', '*.rb')])
            erb_files = Array(Dir[File.join(base, '**', '*.erb')])
            all_files = rb_files + erb_files

            all_files.each do |file|
              stem = file.gsub(generator_root, '')
              content = File.read(file)
              create_file stem, content
            end
          end
        end

        private

        def paths
          [
            'app',
          ]
        end

        def generator_root
          self.class.generator_root
        end
      end
    end
  end
end
