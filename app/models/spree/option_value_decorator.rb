module Spree
  module OptionValueDecorator
    def self.prepended(base)
      base.has_many :ad_hoc_option_values, dependent: :destroy
    end
  end
end

Spree::OptionValue.prepend Spree::OptionValueDecorator
