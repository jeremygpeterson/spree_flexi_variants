((manager) => {
  const update = (selector, callback) => {
    return new Promise((resolve) => {
      $(document).on("keyup", selector, function (e) {
        var text_field = $(this);

        delay(function () {
          // update the hidden price field for this file input
          $(text_field)
            .siblings(".customization_price")
            .val(callback(text_field));

          manager.product.updatePrice();
          resolve();
        }, 1000); // delay
      }); // keyup
    });
  };

  manager.jobs.run(update);
})(SpreeFlexiVariants);
