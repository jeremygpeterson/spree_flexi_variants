# SpreeFlexiVariants

Master branch for Spree 3.3.0+ Read version notes for details.

This is a [spree](http://spreecommerce.com) extension that solves two use cases related to variants. I call them **Ad Hoc Options** and **Product Customizations**.

### Ad Hoc Options

Use these when have numerous (possibly price-altering) product options and you don't want to create variants for each combination.

You can also restrict certain combinations of options from coexisting. These are called **Ad Hoc Exclusions**.

### Product Customizations

Use these when you want the ability to provide a highly customized product e.g. "Cut to length 5.82cm", "Engrave 'thanks for the memories'", "Upload my image". Full control over pricing is provided by the Spree calculator mechanism.

## Version Notes

The branch spree-3-3 version for spree 3.3.0

The branch spree-3-2 version for spree 3.2.0

The branch spree-3-1-stable version for spree 3.1.0

The branch spree-3-0-stable is an somewhat stable version for spree 3.0.0 with updated styles to match.

Working with a older spree? Check out the original gem or one of the many forks. https://github.com/jsqu99/spree_flexi_variants

## Installation

### See the notes in Versionfile if you are using an older version of spree

`gem 'spree_flexi_variants', github: 'collins-lagat/spree_flexi_variants', tag: 'v4.6.2.1'`

`bundle install`

`bundle exec rails g spree_flexi_variants:install`

## API usage

### Payload

To add products with customizations, use the following api: `/api/v2/storefront/cart/add_item`

To add customizations, add the following to the options payload.

```json
{
  "variant_id": "<string>",
  "quantity": "<integer>",
  "public_metadata": {},
  "private_metadata": {},
  "options": {
    "product_customizations": [
      {
        "product_customization_type_id": "<string>",
        "customized_product_options_attributes": [
          {
            "customizable_product_option_id": "<string>",
            "value": "<string>"
          }
        ]
      }
    ],
    "ad_hoc_option_value_ids": ["<string|integer>"]
  }
}
```

### Possible Errors

Note that the Product Customization Type and Customizable Product Option Ids must have already been associated with the product, otherwise the line item will be created without them.

### Fetching Ad Hoc Option Types and Product Customization Types
To fetch _ad hoc option types_ and _product customization types_ using `/api/v2/storefront/products/{{PRODUCT_SLUG}}`, included them in the `includes` query params i.e.

```requests
GET /api/v2/storefront/products/army-green-jacket
Content-Type: application/json

{
  "includes": product_customization_types.customizable_product_options,ad_hoc_option_types.ad_hoc_option_values
}
```

## Examples

Build a 'Cake' product using **Ad Hoc Options** and **Product Customizations**

![Cake](https://raw.github.com/QuintinAdam/spree_flexi_variants/master/doc/custom_cake.png)

Build a 'Necklace' product using **Ad Hoc Options** and **Product Customizations**

![Necklace](https://raw.github.com/jsqu99/spree_flexi_variants/master/doc/necklace_screenshot.png)

Build a 'Pizza' product using **Ad Hoc Options**. Note that the 'multi' option checkboxes come from a partial named after the option name (see app/views/products/ad_hoc_options/\_toppings.html.erb)

![Picture Frame](https://raw.github.com/jsqu99/spree_flexi_variants/master/doc/pizza_screenshot.png)

See the [wiki](https://github.com/jsqu99/spree_flexi_variants/wiki) for more detail.
