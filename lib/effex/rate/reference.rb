require 'active_model'
require 'validates_timeliness'

# TODO: rate should be stored as a string (the exact string supplied)

module Effex
  module Rate
    class Reference
      include ActiveModel::Validations

      attr_accessor :source, :date, :base_currency, :counter_currency, :rate

      # presumably some better constraint on source string format. But for now...
      validates :source, presence: true, length: { minimum: 3 }

      validates :base_currency, presence: true, format: { with: /[A-Z][A-Z][A-Z]/, message: "Incorrect currency format" }
      validates :counter_currency, presence: true, format: { with: /[A-Z][A-Z][A-Z]/, message: "Incorrect currency format" }
      validates :rate, presence: true, numericality: { greater_than: 0.0 }

      validates_date :date, presence: true

      validate :currencies_cannot_be_equal

      def initialize(attribs)
        attribs.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end

        @date = Date.parse("#{@date}") if valid?
      end

      def currencies_cannot_be_equal
        errors.add(:counter_currency, "Cannot be the same as base currency") if @counter_currency == @base_currency
      end

      def to_s
        <<~EOF
        Reference Rate
          srce: #{@source}
          date: #{@date}
          base: #{@base_currency}
          cntr: #{@counter_currency}
          rate: #{@rate}
        EOF
      end
    end
  end
end
