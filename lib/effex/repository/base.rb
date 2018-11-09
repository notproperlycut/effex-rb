module Effex
  module Repository

    # Base class of an Effex data repository. Serves to document the contract
    # for concrete implementations
    class Base

      # Store a rate
      #
      # @param rate [Effex::Rate::Rate] The rate to store
      def save
        raise NotImplementedError, 'Repository must implement save method'
      end

      # Store many rates.
      #
      # Should be overridden when bulk operations are available
      #
      # @param rates [Array<Effex::Rate::Rate>] The rates to store
      def save_all(rates)
        rates.each { |r| save(r) }
      end

      # Locate rates by date, base and counter currencies
      #
      # @param date [Date] The requested quote date
      # @param base [Date] ISO 4217 code of the base
      # @param counter [Date] ISO 4217 code of the counter
      # @return [Array<Hash>] The retrieved quotes
      def find
        raise NotImplementedError, 'Repository must implement find method'
      end

      # Locate rates by date and counter currency
      #
      # @param date [Date] The requested quote date
      # @param counter [Date] ISO 4217 code of the counter
      # @return [Array<Hash>] The retrieved quotes
      def find_by_counter
        raise NotImplementedError, 'Repository must implement find_counter method'
      end
    end
  end
end
