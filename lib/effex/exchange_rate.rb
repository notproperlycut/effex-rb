require 'date'
require 'effex/rate'
require 'effex/repository'

module Effex

  # Entrypoint methods for Effex library
  module ExchangeRate

    # Loads rates from a source and saves them to the :rate repository
    #
    # Requires an implementation of Effex::Source::Base. Requires a repository
    # registered for :rate, using Effex::Repository.register
    #
    # @param source [Object] Object implementing the Effex::Source::Base contract
    def self.load(source)
      rates = source.retrieve.map { |r| Effex::Rate::Rate.new(r) }
      Effex::Repository.for(:rate).save_all(rates)
    end

    # Searches for a single quote from data in the :rate repository
    #
    # If no rate is located, attempts to provide a cross rate
    # using quotes that have the same date and source
    # If quotes from multiple sources are found, returns the first.
    #
    # @param date [Date] date of the requested quote
    # @param base_currency [String] ISO 4217 code of base currency
    # @param counter_currency [String] ISO 4217 code of counter currency
    # @return [Effex::Rate::Rate, nil] Requested quote
    def self.at(date, base_currency, counter_currency)
      # TODO: some more suitable logic here? For now, we just select the first entry we're given
      all_at(date, base_currency, counter_currency)[0]
    end

    # Searches for quotes from data in the :rate repository
    #
    # If no rates are located, attempts to provide cross rates
    # using quotes that have the same date and source
    # Returns valid quotes from all sources.
    #
    # @param date [Date] date of the requested quote
    # @param base_currency [String] ISO 4217 code of base currency
    # @param counter_currency [String] ISO 4217 code of counter currency
    # @return [Array<Effex::Rate::Rate>, nil] Requested quotes
    def self.all_at(date, base_currency, counter_currency)
      repo = Effex::Repository.for(:rate)

      rates = repo.find(date, base_currency, counter_currency)
      return rates unless rates.empty?

      all_cross_rates_at(date, base_currency, counter_currency)
    end

  private
    def self.all_cross_rates_at(date, base_currency, counter_currency)
      repo = Effex::Repository.for(:rate)

      rates1 = repo.find_by_counter(date, base_currency)
      rates2 = repo.find_by_counter(date, counter_currency)

      pairs = rates1.map do |r1|
        r2s = rates2.select do |r2|
          (r2.base_currency == r1.base_currency) && (r2.source == r1.source)
        end

        {rate1: r1, rates2: r2s}
      end

      # TODO: if any pair has rates2 > 1, that's probably an error (duplicate entries in repo)

      unique_pairs = pairs.select do |rp|
        rp[:rates2].length == 1
      end

      unique_pairs.map do |rp|
        Effex::Rate::Cross.new(rp[:rate1], rp[:rates2][0])
      end
    end
  end
end
