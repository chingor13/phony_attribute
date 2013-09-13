# global namespace so you can use the rails 3 "validate :field, phony_plausible: [options]"
class PhonyPlausibleValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    pn = PhonyAttribute::PhoneNumber(value)
    return if pn.nil?

    if !pn.valid?
      record.errors.add(attribute,  options[:message] || :invalid)
    else
      record.errors.add(attribute,  'is a blocked number') if pn.blocked? && !options[:allow_blocked]
      record.errors.add(attribute, :too_short, :count => pn.number.length) if options[:minimum_length] && pn.number.length < options[:minimum_length]
    end
    
  end
end