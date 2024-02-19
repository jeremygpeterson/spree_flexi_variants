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
  s.add_dependency 'spree', spree_version, '< 4.7'
  s.add_dependency 'spree_backend', spree_version, '< 4.7'
  s.add_dependency 'spree_extension'

  s.metadata['rubygems_mfa_required'] = 'true'
end
