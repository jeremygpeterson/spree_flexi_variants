module Spree
  module V2
    module Storefront
      class ProductCustomizationTypeSerializer < ::Spree::V2::Storefront::BaseSerializer
        set_type :product_customization_type

        attributes :name, :presentation, :description

        has_many :customizable_product_options
      end
    end
  end
end
