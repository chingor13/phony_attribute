module PhonyAttribute
  module Attribute
    extend ActiveSupport::Concern

    module ClassMethods
      def phone_attribute(*attributes)
        options = attributes.extract_options!

        attributes.each do |attribute|
          serialize attribute, PhonyAttribute::PhoneNumber

          method_body, line = <<-EOV, __LINE__ + 1
            def #{attribute}=(original_phone_number)
              write_attribute(:#{attribute}, PhonyAttribute::PhoneNumber(original_phone_number))
            end
          EOV
          
          class_eval method_body, __FILE__, line
        end
      end
    end
  end
end