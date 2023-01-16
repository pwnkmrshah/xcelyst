# -*- encoding: utf-8 -*-
# stub: builder_json_web_token 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "builder_json_web_token".freeze
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://gemfury.com" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Travis Herrick".freeze]
  s.date = "2021-02-23"
  s.email = ["travis.herrick@builder.ai".freeze]
  s.homepage = "https://gitlab.builder.ai/builder/builder-bx/bx/blocks/ruby/engines/builder_json_web_token".freeze
  s.rubygems_version = "3.0.3".freeze
  s.summary = "BuilderJsonWebToken".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder_base>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<jwt>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake_tasks>.freeze, [">= 0"])
      s.add_development_dependency(%q<cane>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
    else
      s.add_dependency(%q<builder_base>.freeze, [">= 0"])
      s.add_dependency(%q<jwt>.freeze, [">= 0"])
      s.add_dependency(%q<rake_tasks>.freeze, [">= 0"])
      s.add_dependency(%q<cane>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<builder_base>.freeze, [">= 0"])
    s.add_dependency(%q<jwt>.freeze, [">= 0"])
    s.add_dependency(%q<rake_tasks>.freeze, [">= 0"])
    s.add_dependency(%q<cane>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
  end
end
