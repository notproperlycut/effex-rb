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

      def find_all_by_date(date)
        @rates[date]
      end
    end
  end
end
