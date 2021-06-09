# -*- encoding: utf-8 -*-
# stub: dm-rspec 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "dm-rspec".freeze
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Potapov Sergey".freeze]
  s.date = "2014-08-16"
  s.description = "RSpec matchers for DataMapper".freeze
  s.email = "blake131313@gmail.com".freeze
  s.extra_rdoc_files = ["README.markdown".freeze]
  s.files = ["README.markdown".freeze]
  s.homepage = "http://github.com/greyblake/dm-rspec".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "It's a set of matchers for DataMapper. Something similar to rspec-rails gem.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<dm-validations>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<jeweler>.freeze, [">= 0"])
      s.add_development_dependency(%q<reek>.freeze, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<libnotify>.freeze, [">= 0"])
      s.add_development_dependency(%q<dm-migrations>.freeze, [">= 0"])
      s.add_development_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
    else
      s.add_dependency(%q<dm-core>.freeze, [">= 0"])
      s.add_dependency(%q<dm-validations>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<jeweler>.freeze, [">= 0"])
      s.add_dependency(%q<reek>.freeze, [">= 0"])
      s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
      s.add_dependency(%q<libnotify>.freeze, [">= 0"])
      s.add_dependency(%q<dm-migrations>.freeze, [">= 0"])
      s.add_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<dm-core>.freeze, [">= 0"])
    s.add_dependency(%q<dm-validations>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<jeweler>.freeze, [">= 0"])
    s.add_dependency(%q<reek>.freeze, [">= 0"])
    s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
    s.add_dependency(%q<libnotify>.freeze, [">= 0"])
    s.add_dependency(%q<dm-migrations>.freeze, [">= 0"])
    s.add_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
  end
end
