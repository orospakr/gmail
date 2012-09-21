# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)
require 'gmail/version'

Gem::Specification.new do |s|
  s.name = "gmail"
  s.summary = "A Rubyesque interface to Gmail, with all the tools you will need."
  s.description = "A Rubyesque interface to Gmail, with all the tools you will need.
  Search, read and send multipart emails; archive, mark as read/unread,
  delete emails; and manage labels.
  "
  s.version = Gmail::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Chris Kowalik"]
  s.email = ["chris@nu7hat.ch"]
  s.homepage = "http://github.com/nu7hatch/gmail"
  
  # runtime dependencies
  s.add_dependency "mime", ">= 0.1"
  s.add_dependency "mail", ">= 2.2.1"
  s.add_dependency "gmail_xoauth", ">= 0.3.0"
  
  # development dependencies
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency "mocha", ">= 0.9"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Gmail provider}
  s.test_files = [
      "spec/gmail_spec.rb",
      "spec/spec_helper.rb"
  ]

  s.add_dependency 'mime', ">= 0.1"
  s.add_dependency 'mail', ">= 2.2.1"
  s.add_dependency 'gmail_xoauth', '>=0.4.1'

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
