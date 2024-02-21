module Spree
  module V2
    module Storefront
      module LineItemSerializerDecorator
        def self.prepended(base)
          base.attributes :ad_hoc_option_text, :product_customization_text
        end
      end
    end
  end
end

Spree::V2::Storefront::LineItemSerializer.prepend Spree::V2::Storefront::LineItemSerializerDecorator
