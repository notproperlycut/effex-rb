require 'effex/rate/reference'

module Effex
  module Rate
    class Cross < Reference
      attr_accessor :rate1, :rate2

      validate :sources_are_equal, :dates_are_equal, :base_currencies_are_equal

      def initialize(rate1, rate2)
        @rate1 = rate1
        @rate2 = rate2

        attribs = {
          source: @rate1.source,
          date: @rate1.date,
          base_currency: @rate1.counter_currency,
          counter_currency: @rate2.counter_currency,
          rate: @rate2.rate / @rate1.rate
        }

        super(attribs)
      end

      def sources_are_equal
        errors.add(:rate2, "Rates must have the same source") unless @rate1.source == @rate2.source
      end

      def dates_are_equal
        errors.add(:rate2, "Rates must have the same date") unless @rate1.date == @rate2.date
      end

      def base_currencies_are_equal
        errors.add(:rate2, "Rates must have the same base currency") unless @rate1.base_currency == @rate2.base_currency
      end
    end
  end
end
