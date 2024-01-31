if Spree.version.to_f > 3.7
  module Spree::Cart::AddItemDecorator
    private

    def add_to_line_item(order:, variant:, quantity: nil, public_metadata: {}, private_metadata: {}, options: {})
      options ||= {}
      quantity ||= 1

      line_item = Spree::Dependencies.line_item_by_variant_finder.constantize.new.execute(order: order, variant: variant, options: options)

      line_item_created = line_item.nil?
      if line_item.nil?
        opts = ::Spree::PermittedAttributes.line_item_attributes.flatten.each_with_object({}) do |attribute, result|
          result[attribute] = options[attribute]
        end.merge(currency: order.currency).delete_if { |_key, value| value.nil? }

        line_item = order.line_items.new(quantity: quantity,
                                         variant: variant,
                                         options: opts)
        options[:product_customizations] ||= []
        product_customizations_result = create_product_customizations(line_item: line_item, options: options)
        return product_customizations_result unless product_customizations_result.success?

        options[:product_customizations] = product_customizations_result.value
        line_customization_result = update_line_item_with_customizations(line_item: line_item, currency: order.currency, options: options)
        return line_customization_result unless line_customization_result.success?

        line_item = line_customization_result.value
      else
        line_item.quantity += quantity.to_i
      end

      line_item.target_shipment = options[:shipment] if options.key? :shipment
      line_item.public_metadata = public_metadata.to_h if public_metadata
      line_item.private_metadata = private_metadata.to_h if private_metadata

      return failure(line_item) unless line_item.save

      line_item.reload.update_price

      ::Spree::TaxRate.adjust(order, [line_item]) if line_item_created
      success(order: order, line_item: line_item, line_item_created: line_item_created, options: options)
    end

    def create_product_customizations(line_item:, options:)
      options[:product_customizations] ||= []
      product_customization_type_id_to_customized_product_options_attributes = options[:product_customizations].each_with_object({}) do |product_customization, result|
        result[product_customization[:product_customization_type_id]] = product_customization[:customized_product_options_attributes]
      end
      product_customization_type_ids = options[:product_customizations].pluck(:product_customization_type_id)
      product_customization_types = Spree::ProductCustomizationType.where(id: product_customization_type_ids)
      product_customizations = product_customization_types.map do |product_customization_type|
        result = Spree::SpreeFlexiVariants::ProductCustomizations::Create.call(
          line_item: line_item,
          product_customization_type: product_customization_type,
          customized_product_options_attributes: product_customization_type_id_to_customized_product_options_attributes[product_customization_type.id.to_s]
        )
        return result unless result.success?

        result.value
      end
      success(product_customizations)
    rescue StandardError => e
      message = if Rails.env.development?
                  "Error creating product customizations: #{e.message}"
                else
                  'Error creating product customizations'
                end
      failure(nil, message)
    end

    def update_line_item_with_customizations(line_item:, currency:, options:)
      product_customizations_values = options[:product_customizations] || []

      # Retrieve ad-hoc option values from options or default to an empty array
      # Retrieve ad-hoc option values based on the provided ids and assign them to the line item
      ad_hoc_option_value_ids = options[:ad_hoc_option_values] || []
      result = retrieve_ad_hoc_option_values(ad_hoc_option_value_ids)
      return result unless result.success?

      ad_hoc_option_values = result.value
      line_item.ad_hoc_option_values = ad_hoc_option_values

      # Calculate the offset price based on ad-hoc option values and product customizations
      offset_price = calculate_offset_price(ad_hoc_option_values, product_customizations_values)

      # Set the currency for the line item if specified
      line_item.currency = currency if currency

      # Set the total price for the line item, considering the base variant price and offset
      result = calculate_total_price(line_item, currency, offset_price)
      return result unless result.success?

      line_item.price = result.value

      success(line_item)
    end

    def retrieve_ad_hoc_option_values(ad_hoc_option_value_ids)
      ad_hoc_option_values = Spree::AdHocOptionValue.where(id: ad_hoc_option_value_ids.reject(&:blank?))
      success(ad_hoc_option_values)
    rescue StandardError => e
      message = if Rails.env.development?
                  "Error retrieving ad-hoc option values: #{e.message}"
                else
                  'Error retrieving ad-hoc option values'
                end
      failure(nil, message)
    end

    def calculate_offset_price(ad_hoc_option_values, product_customizations_values)
      ad_hoc_option_values.sum(:price_modifier).to_f +
        product_customizations_values.sum { |product_customization| product_customization.price(variant) }.to_f
    end

    def calculate_total_price(line_item, currency, offset_price)
      total_price = currency ? line_item.variant.price_in(currency).amount + offset_price : line_item.variant.price + offset_price
      success(total_price)
    rescue StandardError => e
      message = if Rails.env.development?
                  "Error calculating total price: #{e.message}"
                else
                  'Error calculating total price'
                end
      failure(nil, message)
    end
  end

  Spree::Cart::AddItem.prepend Spree::Cart::AddItemDecorator
end
