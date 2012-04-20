# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)
require 'gmail/version'

Gem::Specification.new do |s|
  s.name = %q{gmail}
  s.version = Gmail.version.to_s

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Grevich"]
  s.date = %q{2010-10-26}
  s.description = %q{Proides a GMail API provider}
  s.email = %q{chris@nu7hat.ch}
  s.extra_rdoc_files = [
      "LICENSE",
      "README.md"
  ]
  s.files = [
      "LICENSE",
      "README.md",
      "Rakefile",
      "lib/gmail.rb",
      "gmail.gemspec"
  ]
  s.homepage = %q{http://www.nu7hat.ch}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Gmail provider}
  s.test_files = [
      "spec/gmail_spec.rb",
      "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
