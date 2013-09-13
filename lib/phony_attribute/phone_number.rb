module PhonyAttribute
  class PhoneNumber
    BLOCKED_NUMBER = "+17378742833"

    class_attribute :default_country_code
    class_attribute :named_formats
    self.default_country_code = "1"
    self.named_formats = {
      db: {spaces: '', format: :+},
      vcf: {spaces: '-'},
      us_standard: Proc.new{|pn| pn.country_code == "1" ? "(#{pn.area_code}) #{pn.number1}-#{pn.number2}" : pn.format(:international, spaces: ' ') },
      twilio: Proc.new{|pn| "#{pn.area_code}-#{pn.number1}-#{pn.number2}"}
    }
    
    attr_accessor :number, :extension, :parts
    def initialize(number)
      @parts = []

      # pre-processing
      @number, @extension = number.split(/[xX]/)
      return unless @number

      @number = "+#{self.class.default_country_code}#{@number}" if self.class.default_country_code && !@number.match(Regexp.new("^\s*[\+#{self.class.default_country_code}]"))
      begin
        @number = Phony.normalize(@number)
        @parts = Phony.split(@number.to_s)
      rescue
        @number = nil
      end
    end

    def format(fmt = :+, options = {})
      str = nil
      if self.class.named_formats.has_key?(fmt)
        format = self.class.named_formats[fmt]
        if format.respond_to?(:call)
          str = format.call(self)
        else
          options = options.reverse_merge(self.class.named_formats[fmt])
        end
      else
        options = options.reverse_merge({spaces: '', format: fmt})
      end
      str ||= Phony.formatted(number, options) if number
      str += "x#{extension}" if extension
      str
    end

    def to_s
      @to_s ||= format(:us_standard)
    end

    def blocked?
      BLOCKED_NUMBER == format(:db)
    end

    def valid?
      plausible? && @number.length >= 8
    end

    def plausible?
      Phony.plausible?(@number)
    end

    def country_code
      parts[0]
    end

    def area_code
      ac = parts[1]
      ac ? ac : nil # countries that don't have area codes will return false here
    end

    def number1
      parts[2]
    end

    def number2
      parts[3..-1].join("")
    end

    def ==(other)
      to_s == other.to_s
    end

    class << self
      def dump(number)
        return nil if number.nil?
        PhonyAttribute::PhoneNumber(number).format(:db)
      end

      def load(number)
        new(number) unless number.nil? || number.blank?
      end

      def parse(number)
        self.load(number)
      end
    end
  end

  module_function
  def PhoneNumber(value)
    case value
    when PhoneNumber then value
    when String then PhoneNumber.parse(value)
    else
      nil
    end
  end
end