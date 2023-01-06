# -*- encoding: utf-8 -*-
# stub: yabeda-sidekiq 0.8.1 ruby lib

Gem::Specification.new do |s|
  s.name = "yabeda-sidekiq".freeze
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andrey Novikov".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-08-24"
  s.description = "Prometheus exporter for easy collecting most important of your Sidekiq metrics".freeze
  s.email = ["envek@envek.name".freeze]
  s.homepage = "https://github.com/yabeda-rb/yabeda-sidekiq".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Extensible Prometheus exporter for monitoring your Sidekiq".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<anyway_config>.freeze, [">= 1.3", "< 3"])
      s.add_runtime_dependency(%q<sidekiq>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<yabeda>.freeze, ["~> 0.6"])
      s.add_development_dependency(%q<activejob>.freeze, [">= 6.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<anyway_config>.freeze, [">= 1.3", "< 3"])
      s.add_dependency(%q<sidekiq>.freeze, [">= 0"])
      s.add_dependency(%q<yabeda>.freeze, ["~> 0.6"])
      s.add_dependency(%q<activejob>.freeze, [">= 6.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 2.0"])
      s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<anyway_config>.freeze, [">= 1.3", "< 3"])
    s.add_dependency(%q<sidekiq>.freeze, [">= 0"])
    s.add_dependency(%q<yabeda>.freeze, ["~> 0.6"])
    s.add_dependency(%q<activejob>.freeze, [">= 6.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
  end
end
