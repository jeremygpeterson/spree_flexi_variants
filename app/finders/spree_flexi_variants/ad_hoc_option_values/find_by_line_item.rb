module SpreeFlexiVariants
  module AdHocOptionValues
    class FindByLineItem
      def execute(line_item:, options:)
        ad_hoc_option_value_ids = options[:ad_hoc_option_value_ids]
        Spree::AdHocOptionValue.joins(:products)
                               .where(products: { id: line_item.variant.product_id })
                               .where(id: ad_hoc_option_value_ids.reject(&:blank?))
      end
    end
  end
end
