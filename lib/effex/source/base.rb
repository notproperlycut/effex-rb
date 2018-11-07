require 'effex/repository'

module Effex
  module Source
    class Base
      def retrieve
        raise NotImplementedError, 'Source must implement the retrieve method'
      end

      def source_name
        raise NotImplementedError, 'Source must implement the source_name method'
      end

      def decorate(rates)
        rates.map { |r| {source: source_name}.merge(r) }
      end
    end
  end
end
