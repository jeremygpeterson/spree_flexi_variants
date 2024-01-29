module SpreeFlexiVariants
  class Engine < Rails::Engine
    engine_name 'spree_flexi_variants'

    config.autoload_paths += %W(#{config.root}/lib)
    SpreeCalculators = Struct.new(:shipping_methods, :tax_rates, :promotion_actions_create_adjustments,
                                  :promotion_actions_create_item_adjustments, :product_customization_types)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end


    config.after_initialize do |app|
      unless app.config.spree.calculators.respond_to?(:product_customization_types)
        app.config.spree.calculators = SpreeCalculators.new(
          shipping_methods: app.config.spree.calculators.shipping_methods,
          tax_rates: app.config.spree.calculators.tax_rates,
          promotion_actions_create_adjustments: app.config.spree.calculators.promotion_actions_create_adjustments,
          promotion_actions_create_item_adjustments: app.config.spree.calculators.promotion_actions_create_item_adjustments,
          product_customization_types: []
        )
      end
      app.config.spree.calculators.product_customization_types += [
        Spree::Calculator::Engraving,
        Spree::Calculator::AmountTimesConstant,
        Spree::Calculator::ProductArea,
        Spree::Calculator::CustomizationImage,
        Spree::Calculator::NoCharge
      ]
    end

    config.to_prepare &method(:activate).to_proc

    initializer "spree.flexi_variants.preferences", after: "spree.environment" do |app|
      SpreeFlexiVariants::Config = Spree::FlexiVariantsConfiguration.new
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree.flexi_variants.assets.precompile" do |app|
        app.config.assets.precompile += ['spree/frontend/spree_flexi_variants_exclusions.js','spree/backend/orders/flexi_configuration.js'] # ,'spree/frontend/spree-flexi-variants.*' # removed for now until we need the styles
    end

  end
end
