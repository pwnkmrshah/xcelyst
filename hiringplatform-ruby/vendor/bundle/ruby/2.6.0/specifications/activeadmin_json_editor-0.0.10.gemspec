# -*- encoding: utf-8 -*-
# stub: activeadmin_json_editor 0.0.10 ruby lib

Gem::Specification.new do |s|
  s.name = "activeadmin_json_editor".freeze
  s.version = "0.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["allanbreyes".freeze]
  s.date = "2021-07-08"
  s.description = "\"json_input\" field allow to edit json value as json array with using jsoneditor.js from http://jsoneditoronline.org".freeze
  s.email = ["allanbreyes@users.noreply.github.com".freeze]
  s.homepage = "https://github.com/allanbreyes/activeadmin_json_editor".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "add \"json_input\" and \"jsonb_input\" field type to active_admin that allow to edit Postgresql json and jsonb values".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_runtime_dependency(%q<railties>.freeze, [">= 3.0"])
      s.add_runtime_dependency(%q<ace-rails-ap>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_dependency(%q<railties>.freeze, [">= 3.0"])
      s.add_dependency(%q<ace-rails-ap>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
    s.add_dependency(%q<railties>.freeze, [">= 3.0"])
    s.add_dependency(%q<ace-rails-ap>.freeze, [">= 0"])
  end
end
