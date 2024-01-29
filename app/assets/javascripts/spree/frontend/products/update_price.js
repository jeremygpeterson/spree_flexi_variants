/**
 * Spree scripts are defered, so we need to wait for the document to be ready
 * before we can do anything.
 * Apporach referenced from: https://charliereese.ca/page-specific-javascript-ruby-on-rails/
 */

var delay = (function () {
  let timer = 0;
  return function (callback, ms) {
    clearTimeout(timer);
    timer = setTimeout(callback, ms);
  };
})();

((spreeFlexiVariantsProductModule) => {
  Spree.ready(function () {
    // watch for variant changes
    $("#product-variants input[type='radio']").change(function () {
      spreeFlexiVariantsProductModule.updatePrice();
    });

    // 'watch' our configurations
    $(".ad-hoc-option-select").change(function () {
      // get _every_ option drop down and recalculate product price
      // do this immediately, since we are not waiting on the results of the exlusions post
      spreeFlexiVariantsProductModule.updatePrice();
    });

    if ($(".ad-hoc-option-select").length) {
      spreeFlexiVariantsProductModule.updatePrice(); // set the initial price
    }
  }); // ready
})(SpreeFlexiVariants.product);
