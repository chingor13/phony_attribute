# PhonyAttribute [![Build Status](https://travis-ci.org/chingor13/phony_attribute.png)](https://travis-ci.org/chingor13/phony_attribute)

ActiveModel attribute serialization using [phony][phony]. Also wraps the [phony][phony] with a model.

## Usage

Assuming you have a column named `phone_number` on the `addresses` table, you can easily add phone number handling with:

```
class Address < ActiveRecord::Base
  phone_attribute :phone_number
end

address = Address.new({
  phone_number: "2065551234"
})
address.phone_number.format(:us_standard)
=> (206) 555-1234
```

## Validating

`PhonyAttribute` provides validation to `ActiveModel` using the `Phony.plausible?` helper.  To use:

```
class Address < ActiveRecord::Base
  phone_attribute :phone_number
  validates :phone_number, phony_plausible: {
    allow_blocked: false, 
    minimum_length: 9,
    message: "is invalid"
  }
end
```

## Model

`PhonyAttribute::PhoneNumber` can also be used as a standalone model. It wraps the nice methods `Phony` provides with a model that includes named formatting options.

## Formatting

`PhonyAttribute` comes built with a few named formats. You can add your own by adding to the `PhonyAttribute::PhoneNumber.named_formats` hash.  The value can be either an options hash (passed directly to Phony's format) or a callable Proc/lambda that yields the phone number object.


## License

This project rocks and uses MIT-LICENSE.

[phony]: http://github.com/floere/phony