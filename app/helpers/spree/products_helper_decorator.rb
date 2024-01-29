module Spree
  ProductsHelper.module_eval do
    require 'json'

    private

    def ad_hoc_option_value_options(ad_hoc_option_values)
      ad_hoc_option_values.map do |ah_ov|
        [ad_hoc_option_value_presentation_with_price_modifier(ah_ov), ah_ov.id.to_s]
      end
    end

    def price_change_text(ah_ov)
      plus_or_minus = ''

      if ah_ov.price_modifier.positive?
        plus_or_minus = Spree.t('add')
      elsif ah_ov.price_modifier.negative?
        plus_or_minus = Spree.t('subtract')
      end

      ah_ov.price_modifier.zero? ? '' : " (#{plus_or_minus} #{Spree::Money.new(ah_ov.price_modifier.abs)})"
    end

    def ad_hoc_option_value_presentation_with_price_modifier(ah_ov)
      if ah_ov.price_modifier.nil?
        ah_ov.option_value.presentation
      else
        "#{ah_ov.option_value.presentation} #{price_change_text(ah_ov)}"
      end
    end

    def calculator_name(product_customization_type)
      product_customization_type.calculator.class.name.demodulize.underscore
    rescue StandardError
      ''
    end
  end
end
