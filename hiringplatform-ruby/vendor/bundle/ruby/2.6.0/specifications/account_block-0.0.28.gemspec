# -*- encoding: utf-8 -*-
# stub: account_block 0.0.28 ruby lib

Gem::Specification.new do |s|
  s.name = "account_block".freeze
  s.version = "0.0.28"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://gemfury.com" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Travis Herrick".freeze, "Vadym Yershov".freeze]
  s.date = "2021-09-07"
  s.email = ["travis.herrick@builder.ai".freeze, "vyershov@archer-soft.com".freeze]
  s.homepage = "https://gitlab.builder.ai/builder/builder-bx/bx/blocks/ruby/engines/account_block".freeze
  s.rubygems_version = "3.0.3".freeze
  s.summary = "AccountBlock".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder_base>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<builder_json_web_token>.freeze, ["= 0.0.6"])
      s.add_runtime_dependency(%q<bx_block_sms>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<wisper>.freeze, ["= 2.0.1"])
      s.add_runtime_dependency(%q<bcrypt>.freeze, ["= 3.1.16"])
      s.add_runtime_dependency(%q<phonelib>.freeze, ["= 0.6.47"])
      s.add_runtime_dependency(%q<countries>.freeze, ["= 3.0.1"])
      s.add_runtime_dependency(%q<stripe>.freeze, [">= 0"])
      s.add_development_dependency(%q<pg>.freeze, ["= 1.2.3"])
      s.add_development_dependency(%q<rake_tasks>.freeze, ["= 5.1.1"])
      s.add_development_dependency(%q<cane>.freeze, ["= 3.0.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["= 3.10.0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, ["= 4.0.2"])
      s.add_development_dependency(%q<factory_bot>.freeze, ["= 6.1.0"])
    else
      s.add_dependency(%q<builder_base>.freeze, [">= 0"])
      s.add_dependency(%q<builder_json_web_token>.freeze, ["= 0.0.6"])
      s.add_dependency(%q<bx_block_sms>.freeze, [">= 0"])
      s.add_dependency(%q<wisper>.freeze, ["= 2.0.1"])
      s.add_dependency(%q<bcrypt>.freeze, ["= 3.1.16"])
      s.add_dependency(%q<phonelib>.freeze, ["= 0.6.47"])
      s.add_dependency(%q<countries>.freeze, ["= 3.0.1"])
      s.add_dependency(%q<stripe>.freeze, [">= 0"])
      s.add_dependency(%q<pg>.freeze, ["= 1.2.3"])
      s.add_dependency(%q<rake_tasks>.freeze, ["= 5.1.1"])
      s.add_dependency(%q<cane>.freeze, ["= 3.0.0"])
      s.add_dependency(%q<rspec>.freeze, ["= 3.10.0"])
      s.add_dependency(%q<rspec-rails>.freeze, ["= 4.0.2"])
      s.add_dependency(%q<factory_bot>.freeze, ["= 6.1.0"])
    end
  else
    s.add_dependency(%q<builder_base>.freeze, [">= 0"])
    s.add_dependency(%q<builder_json_web_token>.freeze, ["= 0.0.6"])
    s.add_dependency(%q<bx_block_sms>.freeze, [">= 0"])
    s.add_dependency(%q<wisper>.freeze, ["= 2.0.1"])
    s.add_dependency(%q<bcrypt>.freeze, ["= 3.1.16"])
    s.add_dependency(%q<phonelib>.freeze, ["= 0.6.47"])
    s.add_dependency(%q<countries>.freeze, ["= 3.0.1"])
    s.add_dependency(%q<stripe>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, ["= 1.2.3"])
    s.add_dependency(%q<rake_tasks>.freeze, ["= 5.1.1"])
    s.add_dependency(%q<cane>.freeze, ["= 3.0.0"])
    s.add_dependency(%q<rspec>.freeze, ["= 3.10.0"])
    s.add_dependency(%q<rspec-rails>.freeze, ["= 4.0.2"])
    s.add_dependency(%q<factory_bot>.freeze, ["= 6.1.0"])
  end
end
