module Effex
  module Source
    class Test < Base
      def initialize(source, rates = [])
        @source = source || "test_source"
        @rates = rates
      end

      def add_rate(rate)
        @rates << rate
      end

      def source_name
        @source_name
      end

      def retrieve
        decorate(@rates, @source)
      end
    end
  end
end
