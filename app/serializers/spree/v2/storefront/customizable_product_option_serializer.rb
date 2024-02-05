module Spree
  module V2
    module Storefront
      class CustomizableProductOptionSerializer < ::Spree::V2::Storefront::BaseSerializer
        set_type :customizable_product_option

        attributes :name, :presentation, :description, :position

        belongs_to :product_customization_type
      end
    end
  end
end
