# -*- encoding: utf-8 -*-
# stub: bx_block_appointment_management-eb816fd3 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "bx_block_appointment_management-eb816fd3".freeze
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://gemfury.com", "infra_dependencies" => "postgresql,redis" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Vadym Yershov".freeze]
  s.date = "2021-05-27"
  s.email = ["vyershov@archer-soft.com".freeze]
  s.homepage = "https://gitlab.builder.ai/builder/builder-bx/bx/blocks/ruby/engines/bx_block_appointment_management".freeze
  s.rubygems_version = "3.0.3".freeze
  s.summary = "BxBlockAppointmentManagement".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder_base>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<builder_json_web_token>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<account_block>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<bx_block_login-3d0582b5>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<sidekiq>.freeze, ["~> 6.1.0"])
      s.add_development_dependency(%q<pg>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake_tasks>.freeze, [">= 0"])
      s.add_development_dependency(%q<cane>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<factory_bot>.freeze, [">= 0"])
    else
      s.add_dependency(%q<builder_base>.freeze, [">= 0"])
      s.add_dependency(%q<builder_json_web_token>.freeze, [">= 0"])
      s.add_dependency(%q<account_block>.freeze, [">= 0"])
      s.add_dependency(%q<bx_block_login-3d0582b5>.freeze, [">= 0"])
      s.add_dependency(%q<sidekiq>.freeze, ["~> 6.1.0"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<rake_tasks>.freeze, [">= 0"])
      s.add_dependency(%q<cane>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_dependency(%q<factory_bot>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<builder_base>.freeze, [">= 0"])
    s.add_dependency(%q<builder_json_web_token>.freeze, [">= 0"])
    s.add_dependency(%q<account_block>.freeze, [">= 0"])
    s.add_dependency(%q<bx_block_login-3d0582b5>.freeze, [">= 0"])
    s.add_dependency(%q<sidekiq>.freeze, ["~> 6.1.0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<rake_tasks>.freeze, [">= 0"])
    s.add_dependency(%q<cane>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    s.add_dependency(%q<factory_bot>.freeze, [">= 0"])
  end
end
