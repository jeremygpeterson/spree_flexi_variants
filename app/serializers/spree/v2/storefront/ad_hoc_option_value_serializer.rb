module Spree
  module V2
    module Storefront
      class AdHocOptionValueSerializer < ::Spree::V2::Storefront::BaseSerializer
        set_type :ad_hoc_option_value

        attributes :position, :selected, :price_modifier

        belongs_to :ad_hoc_option_type
        belongs_to :option_value
      end
    end
  end
end
