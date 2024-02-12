module Spree
  module Api
    module V2
      module Storefront
        module CartControllerDecorator
          def add_item
            spree_authorize! :update, spree_current_order, order_token
            spree_authorize! :show, @variant

            options = add_item_params[:options] || {}
            customization_options = add_item_params[:customization_options]
            options[:product_customizations_attributes] = customization_options[:product_customizations_attributes] || []
            options[:ad_hoc_option_value_ids] = customization_options[:ad_hoc_option_value_ids] || []

            result = add_item_service.call(
              order: spree_current_order,
              variant: @variant,
              quantity: add_item_params[:quantity],
              public_metadata: add_item_params[:public_metadata],
              private_metadata: add_item_params[:private_metadata],
              options: options
            )

            render_order(result)
          end

          private

          def add_item_params
            params.permit(:quantity, :variant_id, public_metadata: {}, private_metadata: {}, options: {},
                                                  customization_options: {}).with_defaults(customization_options: {})
          end
        end
      end
    end
  end
end

Spree::Api::V2::Storefront::CartController.prepend Spree::Api::V2::Storefront::CartControllerDecorator
