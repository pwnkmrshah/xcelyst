# -*- encoding: utf-8 -*-
# stub: builder_base 0.0.43 ruby lib

Gem::Specification.new do |s|
  s.name = "builder_base".freeze
  s.version = "0.0.43"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://gemfury.com", "infra_dependencies" => "postgresql" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Travis Herrick".freeze]
  s.date = "2021-06-30"
  s.email = ["travis.herrick@builder.ai".freeze]
  s.executables = ["finalize_builder_app".freeze, "update_bds".freeze, "create_builder_app".freeze, "deploy_block".freeze, "trigger_pipeline".freeze, "create_namespace".freeze, "install_blocks".freeze]
  s.files = ["bin/create_builder_app".freeze, "bin/create_namespace".freeze, "bin/deploy_block".freeze, "bin/finalize_builder_app".freeze, "bin/install_blocks".freeze, "bin/trigger_pipeline".freeze, "bin/update_bds".freeze]
  s.homepage = "https://gitlab.builder.ai/builder/builder-bx/bx/blocks/ruby/engines/builder_base".freeze
  s.required_ruby_version = Gem::Requirement.new(["> 2.6.4".freeze, "< 2.6.6".freeze])
  s.rubygems_version = "3.0.3".freeze
  s.summary = "BuilderBase".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, ["= 6.0.3.6"])
      s.add_runtime_dependency(%q<jsonapi.rb>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<fast_jsonapi>.freeze, [">= 0"])
      s.add_development_dependency(%q<pg>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake_tasks>.freeze, [">= 0"])
      s.add_development_dependency(%q<cane>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, ["= 6.0.3.6"])
      s.add_dependency(%q<jsonapi.rb>.freeze, [">= 0"])
      s.add_dependency(%q<fast_jsonapi>.freeze, [">= 0"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<rake_tasks>.freeze, [">= 0"])
      s.add_dependency(%q<cane>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, ["= 6.0.3.6"])
    s.add_dependency(%q<jsonapi.rb>.freeze, [">= 0"])
    s.add_dependency(%q<fast_jsonapi>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<rake_tasks>.freeze, [">= 0"])
    s.add_dependency(%q<cane>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
  end
end
