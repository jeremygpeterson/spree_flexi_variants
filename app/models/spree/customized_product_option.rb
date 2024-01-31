module Spree
  # in populate, params[:customization] contains all the fields supplied by
  # the customization_type_view. Those values are saved in this class
  class CustomizedProductOption < ActiveRecord::Base
    belongs_to :product_customization
    belongs_to :customizable_product_option

    mount_uploader :customization_image, CustomizationImageUploader

    validate :customizable_product_option_must_belong_to_same_product_customization_type_as_product_customization

    def customizable_product_option_must_belong_to_same_product_customization_type_as_product_customization
      return unless customizable_product_option && product_customization
      return unless customizable_product_option.product_customization_type_id != product_customization.product_customization_type_id

      errors.add(:customizable_product_option, :invalid_customizable_product_option)
    end

    def empty?
      value.empty? && !customization_image?
    end
  end
end
