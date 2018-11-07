require 'effex/rate/reference'

module Effex
  module Rate
    class Cross < Reference
      attr_accessor :rate1, :rate2

      validate :sources_are_equal, :dates_are_equal, :base_currencies_are_equal

      def initialize(rate1, rate2)
        @rate1 = rate1
        @rate2 = rate2

        # TODO: rough and ready control over precision of rate here
        attribs = {
          source: @rate1.source,
          date: @rate1.date,
          base_currency: @rate1.counter_currency,
          counter_currency: @rate2.counter_currency,
          rate: "%.3f" % (@rate2.rate_f / @rate1.rate_f)
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

      def to_s
        <<~EOF
        Cross Rate
          srce: #{@source}
          date: #{@date}
          base: #{@base_currency}
          cntr: #{@counter_currency}
          rate: #{@rate}

        [Rate 1]: #{@rate1}
        [Rate 2]: #{@rate2}
        EOF
      end

      def ==(other)
        @source == other.source &&
        @date == other.date &&
        @base_currency == other.base_currency &&
        @counter_currency == other.counter_currency &&
        @rate == other.rate &&
        @rate1 == other.rate1 &&
        @rate2 == other.rate2
      end

      def eql?(other)
        self == other
      end

      def hash
          [@source, @date, @base_currency, @counter_currency, @rate, @rate1.hash, @rate2.hash].hash
      end
    end
  end
end
