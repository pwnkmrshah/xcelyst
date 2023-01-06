# frozen_string_literal: true

require 'builder_base/generators/install/base'

module BxBlockCors
  module Block
    class InstallGenerator < BuilderBase::Generators::Install::Base
      set_file_directory __dir__

      def execute
        super

        add_cors_gem
        install_gems
        add_cors_settings
      end

      private

      def add_cors_gem
        delete_lines(
          'Gemfile',
          [
            "# gem 'rack-cors'"
          ]
        )

        insert_lines(
          'Gemfile',
          nil,
          [
            "gem 'rack-cors'"
          ]
        )
      end

      def install_gems
        require 'bundler'

        Bundler.with_clean_env do
          run "bundle install"
        end
      end

      def add_cors_settings
        insert_lines(
          'config/application.rb',
          '    config.api_only = true',
          [
            '    config.middleware.insert_before 0, Rack::Cors do',
            '      allow do',
            "        origins '*'",
            "        resource '*', :headers => :any, :methods => [:get, :post, :options]",
            '      end',
            '    end'
          ]
        )
      end

      def insert_lines(file_name, target_line, new_lines)
        contents = File.read(file_name)
        if target_line.nil?
          target_position = contents.split("\n").count
        else
          target_position = contents.split("\n").find_index(target_line) + 1
        end

        new_lines.reverse.each do |line|
          next if contents.include? line
          split_contents = contents.split("\n")
          split_contents.insert(target_position, line)
          contents = split_contents.join("\n")
        end
        File.open(file_name, 'w') {|file| file.puts contents }
      end

      def delete_lines(file_name, lines_to_delete)
        contents = File.read(file_name)

        lines_to_delete.each do |line|
          next unless contents.include? line
          split_contents = contents.split("\n")
          split_contents.delete(line)
          contents = split_contents.join("\n")
        end
        File.open(file_name, 'w') {|file| file.puts contents }
      end
    end
  end
end
