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
        rates.map { |r| r.merge({source: source_name}) }
      end
    end
  end
end
