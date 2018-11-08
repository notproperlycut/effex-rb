require 'effex/repository'

module Effex
  module Source

    # Base class of an Effex data source. Serves to document the contract
    # for concrete implementations
    class Base

      # Retrieve a list of quotes from the data source
      #
      # Output must be an array of quotes.
      # Quotes must be hashes with the following keys:
      #   source: string that is unique to the data source
      #   date: date the quote is valid for
      #   base_currency: ISO 4217 code of the base
      #   counter_currency: ISO 4217 code of the counter
      #   rate: the exchange rate
      #
      # @return [Array<Hash>] The retrieved quotes
      def retrieve
        raise NotImplementedError, 'Source must implement the retrieve method'
      end

      def decorate(rates, source)
        rates.map { |r| {source: source}.merge(r) }
      end
    end
  end
end
