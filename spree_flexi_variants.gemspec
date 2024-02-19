lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_flexi_variants/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_flexi_variants'
  s.version     = SpreeFlexiVariants.version
  s.summary     = 'This is a spree extension that solves two use cases related to variants.'
  s.description = 'Spree extension to create product variants as-needed'
  s.required_ruby_version = '>= 2.5'

  # s.original_author   = 'Jeff Squires'
  # s.second_author     = 'Quintin Adam'
  s.author    = 'Collins Lagat'
  s.email     = 'collins@collinslagat.com'
  s.homepage  = 'https://github.com/collins-lagat/spree_flexi_variants'

  s.files = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(%r{^spec/fixtures}) }
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '>= 4.4.0'
  s.add_dependency('carrierwave')
  s.add_dependency('mini_magick')

  s.add_development_dependency 'capybara',           '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner',   '~> 1.0.1'
  s.add_development_dependency 'factory_girl_rails', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',        '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'simplecov', '~> 0.9.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'launchy'
  #remove later
  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'
  s.add_development_dependency 'xray-rails'
  s.add_development_dependency 'quiet_assets'
  s.add_development_dependency 'jazz_fingers'
  s.add_dependency 'spree', spree_version, '< 4.7'
  s.add_dependency 'spree_backend', spree_version, '< 4.7'
  s.add_dependency 'spree_extension'


  s.add_development_dependency 'pg'
  s.add_development_dependency 'spree_dev_tools'

  s.metadata['rubygems_mfa_required'] = 'true'
end
