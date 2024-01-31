module Spree
  class ProductCustomization < ActiveRecord::Base
    belongs_to :product_customization_type
    belongs_to :line_item
    has_many :customized_product_options, dependent: :destroy
    # attr_accessible :product_customization_type_id, :line_item_id
    # TODO: Jeff, add 'required'

    delegate :calculator, to: :product_customization_type
    accepts_nested_attributes_for :customized_product_options
    validates :customized_product_options, presence: true
    validate :product_customization_type_must_belongs_to_same_product_as_line_item

    def product_customization_type_must_belongs_to_same_product_as_line_item
      return unless product_customization_type && line_item
      return unless product_customization_type.products.where(id: line_item.variant.product_id).empty?

      errors.add(:product_customization_type, :invalid_product_customization_type)
    end

    # price might depend on something contained in the variant (like product property value)a
    def price(variant = nil)
      amount = product_customization_type.calculator.compute(self, variant)
    end
  end
end
