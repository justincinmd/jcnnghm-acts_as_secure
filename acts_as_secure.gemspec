# -*- encoding: utf-8 -*-
require File.expand_path("../lib/acts_as_secure/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "jcnnghm-acts_as_secure"
  s.version     = ActsAsSecure::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Justin Cunningham' , '2007 Revolution Health Group LLC.']
  s.email       = ['justin@bulletprooftiger.com']
  s.homepage    = "http://rubygems.org/gems/jcnnghm-acts_as_secure"
  s.summary     = "ActsAsSecure adds an ability to store ActiveRecord model's fields encrypted in a DB."
  s.description = "When a model is marked with acts_as_secure, the :binary type fields are recognized as needed to be stored encrypted.
    The plugin does before_save/after_save/after_find encryption/decryption thus making it transparent for a
    code using the secure models."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "jcnnghm-acts_as_secure"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", "~> 2.4"
  s.add_development_dependency "activerecord", '~> 3.0.4'
  s.add_development_dependency "sqlite3"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
