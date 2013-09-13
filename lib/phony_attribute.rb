module PhonyAttribute
  autoload :Attribute, 'phony_attribute/attribute'
  autoload :PhoneNumber, 'phony_attribute/phone_number'
end

require 'phony'
require 'phony_attribute/railtie'