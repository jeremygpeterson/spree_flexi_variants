> [!WARNING]
> **DO NOT USE** This is an experimental fork to work update to Spee 4.10.x for my highly customizable situation.

# SpreeFlexiVariants

This is a [spree](http://spreecommerce.com) extension that solves two use cases related to variants. I call them **Ad Hoc Options** and **Product Customizations**.

### Ad Hoc Options

Use these when have numerous (possibly price-altering) product options and you don't want to create variants for each combination.

You can also restrict certain combinations of options from coexisting. These are called **Ad Hoc Exclusions**.

### Product Customizations

Use these when you want the ability to provide a highly customized product e.g. "Cut to length 5.82cm", "Engrave 'thanks for the memories'", "Upload my image". Full control over pricing is provided by the Spree calculator mechanism.

## Version Notes

This gem works with Spree `4.x` up to version `4.6.x`. It will **not** work with Spree `4.7.x` and above. Pick the latest tag i.e. `v4.6.x` for the latest version.

Working with Spree 3.0 to 3.3? Check out [Quintin Adam's fork](https://github.com/QuintinAdam/spree_flexi_variants).

Working with an even older Spree version? Check out [the original gem by Jeff Squires](https://github.com/jsqu99/spree_flexi_variants).

## Installation

1. Add this extension to your Gemfile with this line:

   ```ruby
   gem 'spree_flexi_variants', github: 'collins-lagat/spree_flexi_variants', tag: 'v4.6.6'
   ```

2. Install the gem using Bundler

   ```ruby
   bundle install
   ```

3. Copy & run migrations

   ```ruby
   bundle exec rails g spree_flexi_variants:install
   ```

4. Restart your server

If your server was running, restart it so that it can find the assets properly.


## Usage

### Adding Products To Cart With Customizations and Ad Hoc Options
Adding products with customizations and ad hoc options is similar to adding products without them. The only difference is that you need to include the customization and ad hoc options in the payload.

```http
POST /api/v2/storefront/cart/add_item
Content-Type: application/json
X-Spree-Order-Token: <string>

{
  "variant_id": "<string>",
  "quantity": "<integer>",
  "public_metadata": {},
  "private_metadata": {},
  "options": {},
  "customization_options": {
    "product_customizations_attributes": [
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
> [!CAUTION]
> Note that the Product Customization Type and Customizable Product Option Ids must have already been associated with the product, otherwise the line item will be created without them.

### Fetching Ad Hoc Option Types and Product Customization Types
In order to build a form for the user to select customizations and ad hoc options, you need to fetch the available customization and ad hoc option types. In order to do this, you'll need to fetch the product using the storefront API and include the customization and ad hoc option types in the `includes` query params field.
```http
GET /api/v2/storefront/products/army-green-jacket
Content-Type: application/json

{
  "includes": "product_customization_types.customizable_product_options,ad_hoc_option_types.ad_hoc_option_values"
}
```

### Getting Ad Hoc Option and Product Customization Presentation Texts
Whenever you include line items when retrieving the cart, each line item includes a field called `option_text` which contains the presentation texts for regular option types and values. This extension adds two more fields `product_customization_text` and `ad_hoc_option_text` which contain the presentation texts for the product customizations and ad hoc options respectively.

```http
GET /api/v2/storefront/cart
Content-Type: application/json
X-Spree-Order-Token: <string>

{
  "data": {
    "id": "11",
    "type": "cart",
    "attributes": {
      "number": "R823511564",
      "rest_of_attributes": "..."
    },
    "relationships": {
      "line_items": {
        "data": [
          {
            "id": "6",
            "type": "line_item"
          }
        ]
      },
      "rest_of_relationships": "..."
    },
    "includes": [
      {
        "id": "6",
        "type": "line_item",
        "attributes": {
          "name": "3 4 Sleeve T Shirt",
          "options_text": "Color: white, Size: XS",
          "ad_hoc_option_text": "Length: Maxi",
          "product_customization_text": "Badges($2.00): (How many?: 2)",
          "rest_of_attributes": "..."
        },
        "relationships": {
          "variant": {
            "data": {
              "id": "130",
              "type": "variant"
            }
          },
          "rest_of_relationships": "..."
        }
      }
    ]
  }
}
```

## Limitations

- Doesn't support spree 4.7.x and above
- Products with different customizations and ad hoc options can't be added to the same cart at the same time. Attempting to add a product with different customizations and ad hoc options to the same cart will only increase the quantity of the first product.
- Support for `spree_frontend` was removed in version.

## Documentation

See the [wiki](https://github.com/jsqu99/spree_flexi_variants/wiki) for more detail.
