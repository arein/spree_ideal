# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_ideal'
  s.version     = '2.4.3'
  s.summary     = 'Add iDEAL payment to spree'
  s.description = ''
  s.required_ruby_version = '>= 2.2.1'

  s.author            = 'Alexander-Derek Rein'
  s.email             = 'adr@ceseros.de'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4'
  s.add_dependency 'actionpack-xml_parser'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
end
