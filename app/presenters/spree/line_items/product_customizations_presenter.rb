module Spree
  module LineItems
    class ProductCustomizationsPresenter
      WORDS_CONNECTOR = ', '.freeze
      BLOCKS_CONNECTOR = '\n'.freeze

      attr_reader :line_item

      delegate :product_customizations, to: :line_item

      def initialize(line_item)
        @line_item = line_item
      end

      def to_sentence
        customizations = product_customizations
        customizations = present_customizations(customizations)

        join_customizations(customizations)
      end

      private

      def present_customizations(customizations)
        customizations.map do |customization|
          present_customization(customization)
        end
      end

      def present_customization(customization)
        price_adjustment = if customization.price.zero?
                             ''
                           else
                             "(#{Spree::Money.new(customization.price)})"
                           end
        options = customization.customized_product_options.map do |option|
          present_customized_product_option(option)
        end
        options_text = options.to_sentence(words_connector: WORDS_CONNECTOR, two_words_connector: WORDS_CONNECTOR)
        "#{customization.product_customization_type.presentation}#{price_adjustment}: (#{options_text})"
      end

      def present_customized_product_option(option)
        value = if option.customization_image?
                  File.basename option.customization_image.url
                else
                  option.value
                end
        "#{option.customizable_product_option.presentation}: #{value}"
      end

      def join_customizations(customizations)
        customizations.to_sentence(words_connector: BLOCKS_CONNECTOR, two_words_connector: BLOCKS_CONNECTOR)
      end
    end
  end
end
