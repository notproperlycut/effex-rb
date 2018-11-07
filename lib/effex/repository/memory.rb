module Effex
	module Repository
		class Memory < Base
      def initialize
        @rates = {}
      end

      def save(rate)
        @rates[rate.date] ||= []
        @rates[rate.date] << rate
        return rate
      end

      def find(date, base, counter)
        (@rates[date] || []).select do |r|
          (r.base_currency == base) && (r.counter_currency == counter)
        end
      end

      def to_s
        "Memory repo with #{@rates.length} dates"
      end
    end
  end
end
