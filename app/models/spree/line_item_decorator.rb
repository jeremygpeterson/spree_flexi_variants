module Spree
  module LineItemDecorator
    def self.prepended(base)
      base.has_many :ad_hoc_option_values_line_items, dependent: :destroy
      base.has_many :ad_hoc_option_values, through: :ad_hoc_option_values_line_items
      base.has_many :product_customizations, dependent: :destroy

      base.accepts_nested_attributes_for :product_customizations

      base.after_create :update_price_from_customizations_and_options!
    end

    def ad_hoc_option_text
      @ad_hoc_option_text ||= Spree::LineItems::AdHocOptionsPresenter.new(self).to_sentence
    end

    def product_customization_text
      @product_customization_text ||= Spree::LineItems::ProductCustomizationsPresenter.new(self).to_sentence
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

