module Spree
  module LineItems
    class AdHocOptionsPresenter
      WORDS_CONNECTOR = ', '.freeze

      attr_reader :line_item

      delegate :ad_hoc_option_values, to: :line_item

      def initialize(line_item)
        @line_item = line_item
      end

      def to_sentence
        ad_hoc_options = ad_hoc_option_values
        ad_hoc_options = sort_options(ad_hoc_options)
        ad_hoc_options = present_options(ad_hoc_options)

        join_options(ad_hoc_options)
      end

      private

      def sort_options(ad_hoc_options)
        ad_hoc_options.sort_by { |o| o.option_type.position }
      end

      def present_options(ad_hoc_options)
        ad_hoc_options.map do |aov|
          method = "present_#{aov.ad_hoc_option_type.option_type.name}_option"

          respond_to?(method, true) ? send(method, aov) : present_option(aov)
        end
      end

      def present_option(ad_hoc_option)
        "#{ad_hoc_option.ad_hoc_option_type.option_type.presentation}: #{ad_hoc_option.option_value.presentation}"
      end

      def join_options(ad_hoc_options)
        ad_hoc_options.to_sentence(words_connector: WORDS_CONNECTOR, two_words_connector: WORDS_CONNECTOR)
      end
    end
  end
end
