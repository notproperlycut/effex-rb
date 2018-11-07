require 'date'

module Effex
  module ExchangeRate
    def self.load(source)
      rates = source.retrieve.map { |r| Effex::Rate::Reference.new(r) }
      rates.each { |r| Effex::Repository.for(:reference_rate).save(r) }
    end

    def self.at(date, base_currency, counter_currency)
      all_at(date, base_currency, counter_currency)[0]
    end

    def self.all_at(date, base_currency, counter_currency)
      repo = Effex::Repository.for(:reference_rate)
      repo.find(date, base_currency, counter_currency)
    end
  end
end
