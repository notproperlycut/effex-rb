require 'effex/repository'

module Effex
  module Source
    class Base
      def retrieve
        raise NotImplementedError, 'Source must implement the retrieve method'
      end

      def decorate(rates, source)
        rates.map { |r| {source: source}.merge(r) }
      end
    end
  end
end
