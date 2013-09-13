module PhonyAttribute
  class Railtie < ::Rails::Railtie

    initializer "phony_attribute" do
      require 'phony_attribute/phony_plausible_validator'
      ActiveSupport.on_load :active_record do
        include PhonyAttribute::Attribute
      end
    end

  end
end