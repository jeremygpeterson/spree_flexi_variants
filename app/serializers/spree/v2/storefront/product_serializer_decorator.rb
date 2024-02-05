module Spree
  module V2
    module Storefront
      module ProductSerializerDecorator
        def self.prepended(base)
          base.has_many :product_customization_types
          base.has_many :ad_hoc_option_types
        end
      end
    end
  end
end

Spree::V2::Storefront::ProductSerializer.prepend(Spree::V2::Storefront::ProductSerializerDecorator)
