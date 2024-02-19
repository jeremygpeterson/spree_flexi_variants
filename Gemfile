source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 7.0.0'
gem 'rails-controller-testing'
gem 'spree', github: 'spree/spree', tag: 'v4.6.2'
gem 'spree_backend', github: 'spree/spree_backend', tag: 'v4.6.2'

gemspec
