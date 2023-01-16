# -*- encoding: utf-8 -*-
# stub: sidekiq_alive 2.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "sidekiq_alive".freeze
  s.version = "2.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Artur Pan\u0303ach".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-09-27"
  s.description = "SidekiqAlive offers a solution to add liveness probe of a Sidekiq instance.\n\n  How?\n\n  A http server is started and on each requests validates that a liveness key is stored in Redis. If it is there means is working.\n\n  A Sidekiq job is the responsable to storing this key. If Sidekiq stops processing jobs\n  this key gets expired by Redis an consequently the http server will return a 500 error.\n\n  This Job is responsible to requeue itself for the next liveness probe.".freeze
  s.email = ["arturictus@gmail.com".freeze]
  s.homepage = "https://github.com/arturictus/sidekiq_alive".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Liveness probe for sidekiq on Kubernetes deployments.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["> 1.16"])
      s.add_development_dependency(%q<mock_redis>.freeze, [">= 0"])
      s.add_development_dependency(%q<rack-test>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-sidekiq>.freeze, ["~> 3.0"])
      s.add_runtime_dependency(%q<sidekiq>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<webrick>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["> 1.16"])
      s.add_dependency(%q<mock_redis>.freeze, [">= 0"])
      s.add_dependency(%q<rack-test>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<rspec-sidekiq>.freeze, ["~> 3.0"])
      s.add_dependency(%q<sidekiq>.freeze, [">= 0"])
      s.add_dependency(%q<webrick>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["> 1.16"])
    s.add_dependency(%q<mock_redis>.freeze, [">= 0"])
    s.add_dependency(%q<rack-test>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<rspec-sidekiq>.freeze, ["~> 3.0"])
    s.add_dependency(%q<sidekiq>.freeze, [">= 0"])
    s.add_dependency(%q<webrick>.freeze, [">= 0"])
  end
end
