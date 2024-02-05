module Spree
  module V2
    module Storefront
      class AdHocOptionTypeSerializer < ::Spree::V2::Storefront::BaseSerializer
        set_type :ad_hoc_option_type

        attributes :price_modifier_type, :is_required

        belongs_to :product
        belongs_to :option_type
        has_many :ad_hoc_option_values
      end
    end
  end
end
