# -*- encoding: utf-8 -*-
# stub: yabeda-http_requests 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "yabeda-http_requests".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/yabeda-rb/yabeda-http_requests", "source_code_uri" => "https://github.com/yabeda-rb/yabeda-http_requests" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Dmitry Salahutdinov".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-01-25"
  s.description = "Extends Yabeda metrics to collect external calls".freeze
  s.email = ["dsalahutdinov@gmail.com".freeze]
  s.homepage = "https://github.com/yabeda-rb/yabeda-http_requests".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Monitoring of external services HTTP/HTTPS calls".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sniffer>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<yabeda>.freeze, [">= 0"])
    else
      s.add_dependency(%q<sniffer>.freeze, [">= 0"])
      s.add_dependency(%q<yabeda>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<sniffer>.freeze, [">= 0"])
    s.add_dependency(%q<yabeda>.freeze, [">= 0"])
  end
end
