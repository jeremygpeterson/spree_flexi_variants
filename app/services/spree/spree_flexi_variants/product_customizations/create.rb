module Spree
  module SpreeFlexiVariants
    module ProductCustomizations
      class Create
        prepend Spree::ServiceModule::Base

        def call(line_item:, product_customization_type:, customized_product_options_attributes:)
          product_customization = Spree::ProductCustomization.new(
            line_item: line_item,
            product_customization_type: product_customization_type,
            customized_product_options_attributes: customized_product_options_attributes
          )
          ApplicationRecord.transaction do
            return failure(product_customization) unless product_customization.save
          end

          success(product_customization)
        end
      end
    end
  end
end
