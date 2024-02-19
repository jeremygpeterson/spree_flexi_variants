source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 7.0.0'
gem 'spree', github: 'spree/spree', tag: 'v4.6.2'
gem 'spree_backend', github: 'spree/spree_backend', tag: 'v4.6.2'

group :test do
  gem 'factory_girl_rails'
  gem 'pg'
  gem 'rails-controller-testing'
end

gemspec
