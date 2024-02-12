module Spree
  module LineItemDecorator
    def self.prepended(base)
      base.has_many :ad_hoc_option_values_line_items, dependent: :destroy
      base.has_many :ad_hoc_option_values, through: :ad_hoc_option_values_line_items
      base.has_many :product_customizations, dependent: :destroy

      base.accepts_nested_attributes_for :product_customizations

      base.after_create :update_price_from_customizations_and_options!
    end

    def options_text
      str = []
      unless ad_hoc_option_values.empty?

        # TODO: group multi-select options (e.g. toppings)
        str << ad_hoc_option_values.each do |pov|
        end.join(',')
      end # unless empty?

      unless product_customizations.empty?
        product_customizations.each do |customization|
          price_adjustment = customization.price == 0 ? '' : " (#{Spree::Money.new(customization.price)})"
          str << "#{customization.product_customization_type.presentation}#{price_adjustment}"
          customization.customized_product_options.each do |option|
            next if option.empty?

            str << if option.customization_image?
                     "#{option.customizable_product_option.presentation} = #{File.basename option.customization_image.url}"
                   else
                     "#{option.customizable_product_option.presentation} = #{option.value}"
                   end
          end # each option
        end # each customization
      end # unless empty?

      str.join('\n')
    end

    def cost_price
      (variant.cost_price || 0) + ad_hoc_option_values.map(&:cost_price).inject(0, :+)
    end

    def cost_money
      Spree::Money.new(cost_price, currency: currency)
    end

    def update_price
      offset_price = calculate_offset_price
      currency_price = variant.price_in(order.currency)

      self.price = if currency_price.amount.present?
                     currency_price.price_including_vat_for(tax_zone: tax_zone) + offset_price
                   else
                     0
                   end
    end

    private

    def update_price_from_customizations_and_options!
      offset_price = calculate_offset_price
      self.price = price + offset_price
      save
    end

    def calculate_offset_price
      ad_hoc_option_values.sum(:price_modifier).to_f +
        product_customizations.sum { |product_customization| product_customization.price(variant) }.to_f
    end
  end

  LineItem.prepend LineItemDecorator
end
