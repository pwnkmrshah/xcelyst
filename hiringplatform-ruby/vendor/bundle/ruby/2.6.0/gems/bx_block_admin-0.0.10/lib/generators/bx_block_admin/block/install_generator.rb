# frozen_string_literal: true

require 'builder_base/generators/install/base'

module BxBlockAdmin
  module Block
    class InstallGenerator < BuilderBase::Generators::Install::Base
      set_file_directory __dir__

      source_root File.expand_path('templates', __dir__)

      def execute
        super

        change_application_controller
        add_template_files
        add_activeadmin_routes
        add_application_middleware
        add_gems
        install_gems
      end

      private

      def change_application_controller
        file_name = 'app/controllers/application_controller.rb'
        text = File.read(file_name)
        new_contents = text.gsub(/ActionController::API/, "ActionController::Base")
        File.open(file_name, 'w') {|file| file.puts new_contents }

        insert_lines(
          'app/controllers/application_controller.rb',
          'class ApplicationController < ActionController::Base',
          [
            '  protect_from_forgery unless: -> { request.format.json? }'
          ]
        )
      end

      def add_template_files
        templates = [
          ['active_admin.rb', 'config/initializers/active_admin.rb'],
          ['manifest.js', 'app/assets/config/manifest.js']
        ].freeze

        templates.each do |params|
          template params.first, (params.second.present? ? params.second : params.first)
        end
      end

      def add_activeadmin_routes
        insert_lines(
          'config/routes.rb',
          'Rails.application.routes.draw do',
          [
            '  ActiveAdmin.routes(self)',
            '  devise_for :admin_users, ActiveAdmin::Devise.config'
          ]
        )
      end

      def add_application_middleware
        insert_lines(
          'config/application.rb',
          '    config.api_only = true',
          [
            '    config.middleware.use Rack::MethodOverride',
            '    config.session_options',
            '    config.middleware.use ActionDispatch::Session::CookieStore, ',
            '    config.middleware.use ActionDispatch::Cookies',
            "    config.session_store :cookie_store, key: '_interslice_session'",
            '    config.middleware.use ActionDispatch::Flash'
          ]
        )
      end

      def add_gems
        insert_lines(
          'Gemfile',
          nil,
          [
            "gem 'active_admin_datetimepicker'",
            "gem 'activeadmin_json_editor'",
            "gem 'active_admin_role'",
            "gem 'activeadmin'",
            "gem 'sassc-rails'"
          ]
        )
      end

      def install_gems
        require 'bundler'

        Bundler.with_clean_env do
          run "bundle install"
        end
      end

      def insert_lines(file_name, target_line, new_lines)
        contents = File.read(file_name)
        if target_line.nil?
          target_position = contents.split("\n").count
        else
          target_position = contents.split("\n").find_index(target_line) + 1
        end

        new_lines.each do |line|
          next if contents.include? line
          split_contents = contents.split("\n")
          split_contents.insert(target_position, line)
          contents = split_contents.join("\n")
        end
        File.open(file_name, 'w') {|file| file.puts contents }
      end
    end
  end
end
