const SpreeFlexiVariants = { product: {}, jobs: {} };

SpreeFlexiVariants.product = {
  // Parameters
  currency: null,
  basePrice: null,
  variantPriceMap: {},
  priceModifierMap: {},
  doesProductHaveVariants: null,

  // Methods
  computeVariantPriceDiff: function (basePrice) {
    const context = this;
    let variantPrice = 0;

    $("#product-variants input[type='radio']:checked").each(function () {
      const variantId = $(this).data("variant-id");
      variantPrice = context.variantPriceMap[variantId];
    });

    if (this.doesProductHaveVariants) {
      return variantPrice - basePrice;
    } else {
      return variantPrice; // don't return a negative number if we don't have any variants
    }
  },

  // stolen from http://stackoverflow.com/questions/18082/validate-numbers-in-javascript-isnumeric
  isNumeric: function (input) {
    return input - 0 == input && input.length > 0;
  },

  computeConfigurationPrice: function () {
    const context = this;
    let configurationPrice = 0;

    // for selects or checkboxes
    $("select.ad-hoc-option-select, input:checked.ad-hoc-option-select").each(
      function () {
        // the prompt: 'None' in the select tag yields an empty string, which I can't use in the price calcuation
        var val = $(this).val();

        // now in case we are a multiple select, de-array
        if ($.isArray(val)) {
          $.each(val, function (index, value) {
            if (context.isNumeric(value)) {
              configurationPrice += context.priceModifierMap[value];
            }
          });
        } else {
          if (context.isNumeric(val)) {
            configurationPrice += context.priceModifierMap[val];
          }
        }
      },
    );
    return configurationPrice;
  },

  computeCustomizationPrice: function () {
    const context = this;
    let price = 0;

    // for selects or checkboxes
    $(".customization_price").each(function () {
      const val = $(this).val();

      if (context.isNumeric(val)) {
        price += Number.parseFloat(val);
      }
    });

    return price;
  },

  // we start off the page w/ a known base price, a known set of
  // possible configurations (ad_hoc_option_values), and no customizations

  // 'updatePrice()' takes the base price + current 'configuration' adjustments + 'customization' adjustments

  updatePrice: function () {
    const curVariantPriceDiff = this.computeVariantPriceDiff(this.basePrice);
    const curConfigurationPrice = this.computeConfigurationPrice();
    const curCustomizationPrice = this.computeCustomizationPrice();
    const curPrice =
      this.basePrice +
      curVariantPriceDiff +
      curConfigurationPrice +
      curCustomizationPrice;

    const region = $.formatCurrency.getRegionFromCurrency(this.currency);
    $(".price.selling")
      .text(curPrice.toFixed(2))
      .formatCurrency({ region: region });
  },
};

SpreeFlexiVariants.jobs = {
  // Parameters
  jobs: [],

  // Methods
  _createJob: function (callback) {
    return {
      id: Symbol(),
      callback,
    };
  },
  add: function (callback) {
    this.jobs.push(this._createJob(callback));
  },
  remove: function (id) {
    this.jobs = this.jobs.filter((job) => job.id !== id);
  },
  run: function () {
    this.jobs.forEach((job) => {
      job.callback();
      this.remove(job.id);
    });
  },
};
