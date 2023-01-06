# -*- encoding: utf-8 -*-
# stub: yabeda-prometheus 0.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "yabeda-prometheus".freeze
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/yabeda-rb/yabeda-prometheus/blob/master/CHANGELOG.md", "homepage_uri" => "https://github.com/yabeda-rb/yabeda-prometheus", "source_code_uri" => "https://github.com/yabeda-rb/yabeda-prometheus" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andrey Novikov".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-12-30"
  s.email = ["envek@envek.name".freeze]
  s.homepage = "https://github.com/yabeda-rb/yabeda-prometheus".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Extensible Prometheus exporter for your application".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<prometheus-client>.freeze, [">= 0.10", "< 3.0"])
      s.add_runtime_dependency(%q<yabeda>.freeze, ["~> 0.10"])
      s.add_runtime_dependency(%q<rack>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<prometheus-client>.freeze, [">= 0.10", "< 3.0"])
      s.add_dependency(%q<yabeda>.freeze, ["~> 0.10"])
      s.add_dependency(%q<rack>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 2.0"])
      s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<prometheus-client>.freeze, [">= 0.10", "< 3.0"])
    s.add_dependency(%q<yabeda>.freeze, ["~> 0.10"])
    s.add_dependency(%q<rack>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
  end
end
