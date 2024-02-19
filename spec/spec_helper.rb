# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('dummy/config/environment.rb', __dir__)

require 'spree_dev_tools/rspec/spec_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

require 'spree_flexi_variants/factories'

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
end

end
