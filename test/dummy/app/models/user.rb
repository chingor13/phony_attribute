class User < ActiveRecord::Base

  phone_attribute :phone_number, default_country_code: 'US', format: :+, spaces: ''
  validates :phone_number, phony_plausible: {minimum_length: 9}, presence: true

end