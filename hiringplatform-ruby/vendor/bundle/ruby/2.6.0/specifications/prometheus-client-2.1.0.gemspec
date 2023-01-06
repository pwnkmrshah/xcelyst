# -*- encoding: utf-8 -*-
# stub: prometheus-client 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "prometheus-client".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ben Kochie".freeze, "Chris Sinjakli".freeze, "Daniel Magliola".freeze]
  s.date = "2020-06-29"
  s.email = ["superq@gmail.com".freeze, "chris@gocardless.com".freeze, "dmagliola@crystalgears.com".freeze]
  s.homepage = "https://github.com/prometheus/client_ruby".freeze
  s.licenses = ["Apache 2.0".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "A suite of instrumentation metric primitivesthat can be exposed through a web services interface.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<benchmark-ips>.freeze, [">= 0"])
      s.add_development_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
    else
      s.add_dependency(%q<benchmark-ips>.freeze, [">= 0"])
      s.add_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<benchmark-ips>.freeze, [">= 0"])
    s.add_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
  end
end
