module BuilderBase
  module Block
    class CreateGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_options [
        :author,
        :email,
      ]

      BASES = {
        :controllers => BuilderBase::ApplicationController.to_s,
        :models      => BuilderBase::ApplicationRecord.to_s,
        :jobs        => BuilderBase::ApplicationJob.to_s,
        :mailers     => BuilderBase::ApplicationMailer.to_s,
      }.freeze

      def execute
        require 'digest/sha2'

        validate!

        # this line is likely really only necessary for development purposes
        # when running this generator repeatedly in the same workspace
        #bundle_install

        template 'cane', '.cane'
        template 'Rakefile'
        template 'gitlab-ci.yml', '.gitlab-ci.yml'

        update_gem
        update_engine
        update_specs
        update_dummy_app

        update_base_classes
      end

      private

      def validate!
        return if gemspec_file
        return if route_prefix.length < 20 && path_name.match(/^bx_block_\w+/)

        puts "Invalid block name: #{path_name.inspect}"
        puts "Block names must start with 'bx_block_'"
        puts 'and the route prefix can be no longer than 19 characters.'

        exit 1
      end

      def update_gem
        template 'gemspec.erb', gemspec
        template 'Gemfile.erb', 'Gemfile'
        remove_file File.join('lib', path_name, 'version.rb')
      end

      def update_engine
        template 'engine.rb.erb', File.join('lib', path_name, 'engine.rb')
        template 'my_block.rb.erb', File.join('lib', "#{path_name}.rb")
      end

      def update_specs
        spec_template 'spec_helper.rb'
        spec_template 'rails_helper.rb'

        spec_template 'factory_bot.rb', 'support/unit'
      end

      def update_dummy_app
        gsub_file 'spec/dummy/config/routes.rb', /^.*mount.*\n/, ''
        template 'install_generator.rb.erb', install_generator_path

        dummy_template 'database.yml.erb', 'config/database.yml'
        dummy_template 'schema.rb', 'db/schema.rb'
      end

      def bundle_install
        original    = 'https://gem.fury.io/'
        credentials = "https://#{ENV['BUNDLE_GEM__FURY__IO']}@gem.fury.io/"

        gsub_file 'Gemfile', original, credentials
        Bundler.with_clean_env { run 'bundle install' }
        gsub_file 'Gemfile', credentials, original
        gsub_file 'Gemfile.lock', credentials, original
      end

      def update_base_classes
        BASES.each do |root_path, builder_class_name|
          file_name = File.basename(builder_class_name.underscore)
          path = File.join('app', root_path.to_s, path_name, file_name) + '.rb'
          next unless File.exist?(path)

          replace_class_for path, file_name, builder_class_name
        end
      end

      def replace_class_for(path, file_name, builder_class_name)
        source_class = file_name.camelcase
        search       = /#{source_class} < .*/
        replace      = "#{source_class} < #{builder_class_name}"

        gsub_file path, search, replace
      end

      def spec_template(source, sub_folder = nil)
        path = sub_folder ? File.join('spec', sub_folder) : 'spec'
        template source, File.join(path, source)
      end

      def dummy_template(source, dest)
        template source, File.join(dummy_root, dest)
      end

      def dummy_root
        @dummy_root ||= File.join('spec', 'dummy')
      end

      def install_generator_path
        File.join \
          'lib',
          'generators',
          path_name,
          'block',
          'install_generator.rb'
      end

      def route_prefix
        @route_prefix ||= path_name.gsub(/^bx_block_/, '')
      end

      def author
        @author ||= options['author']
      end

      def email
        @email ||= options['email']
      end

      def gemspec
        @gemspec ||= gemspec_file || "#{gem_name}.gemspec"
      end

      def path_name
        @path_name ||= File.basename(destination_root)
      end

      def class_name
        @class_name ||= path_name.gsub(/-/, '_').camelcase
      end

      def gem_name
        @gem_name ||=
          (gem_spec && gem_spec.name) || path_name
      end

      def gem_version
        return @gem_version if defined?(@gem_version)
        return @gem_version = '0.0.1' unless gemspec_file
        @gem_version = gem_spec.version.to_s
      end

      def gemspec_file
        return @gemspec_file if defined?(@gemspec_file)
        @gemspec_file = Dir['*.gemspec'].first
      end

      def gem_spec
        return @gem_spec if defined?(@gem_spec)
        return @gem_spec = nil unless gemspec_file
        @gem_spec = Gem::Specification.load(gemspec_file)
      end
    end
  end
end
