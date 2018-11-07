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

      def source_name
        @source_name
      end

      def retrieve
        decorate(@rates)
      end
    end
  end
end
