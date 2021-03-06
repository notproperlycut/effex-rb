require 'effex/rate/rate'

module Effex
  module Rate

    # Represents an cross rate (quote)
    class Cross < Rate
      attr_accessor :rate1, :rate2

      validate :sources_are_equal, :dates_are_equal, :base_currencies_are_equal

      # Initialize a cross rate object
      #
      # Rates to be crossed, must have the same date and source attributes
      #
      # @param rate1 [Effex::Rate::Rate] pair to cross
      # @param rate2 [Effex::Rate::Rate] pair to cross
      def initialize(rate1, rate2)
        @rate1 = rate1
        @rate2 = rate2

        # TODO: rough and ready control over precision of rate here.
        # Can find a more appropriate rule?
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
        quote = "#{@base_currency}/#{@counter_currency} #{@rate}"
        from_quote1 = "#{@rate1.base_currency}/#{@rate1.counter_currency} #{@rate1.rate}"
        from_quote2 = "#{@rate2.base_currency}/#{@rate2.counter_currency} #{@rate2.rate}"
        <<~EOF
        Cross Rate
          quote: #{quote}
          date:  #{@date}
          srce:  #{@source}
          from:  #{from_quote1}, #{from_quote2}
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
