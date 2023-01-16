module BuilderBase
  module Blocks
    class InstallGenerator < Rails::Generators::Base
      def execute
        blocks.each do |root, commands|
          commands.each do |command|
            next unless block_install_command?(command)
            generate command
          end
        end
      end

      private

      def blocks
        groups = Rails::Generators.sorted_groups

        groups.filter do |key, commands|
          commands.any? do |command|
            block_install_command? command
          end
        end
      end

      def block_install_command?(command)
        command.match(/:block:install$/)
      end
    end
  end
end
