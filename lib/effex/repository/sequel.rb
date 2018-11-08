require 'sequel'

DB = Sequel.sqlite # memory database, requires sqlite3

module Effex
  module Repository
    # I thought this would use ActiveRecord, but that would likely be
    # overkill given how simple the API below is

    class Sequel < Base

      def initialize
        DB.create_table :rates do
          primary_key :id
          String :source
          String :base_currency
          String :counter_currency
          Date   :date
          String :rate

          index [:date, :base_currency, :counter_currency]
          unique [:source, :base_currency, :counter_currency, :date]
        end
      end

      def save(rate)
        DB[:rates].insert({
          source: rate.source,
          date: rate.date,
          base_currency: rate.base_currency,
          counter_currency: rate.counter_currency,
          rate: rate.rate
        })
      end

      def find(date, base, counter)
        DB[:rates].where(date: date, base_currency: base, counter_currency: counter).map do |r|
          Effex::Rate::Reference.new(r)
        end
      end

      def find_by_counter(date, counter)
        DB[:rates].where(date: date, counter_currency: counter).map do |r|
          Effex::Rate::Reference.new(r)
        end
      end

      def to_s
        "SQL (sequel) repo with #{DB[:rates].count} rates"
      end
    end
  end
end
