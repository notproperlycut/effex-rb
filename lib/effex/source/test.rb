module Effex
  module Source
    class Test < Base
      def initialize(source_name, rates = [])
        @source_name = source_name || "test_source"
        @rates = rates
      end

      def add_rate(rate)
        @rates << rate
      end

      def retrieve
        @rates.map { |r| r.merge({source: @source_name}) }
      end
    end
  end
end
