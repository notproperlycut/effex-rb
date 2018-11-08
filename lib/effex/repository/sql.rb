require 'sequel'

module Effex
  module Repository
    # I thought this would use ActiveRecord - but given how simple this
    # API is, that might have been overkill. Chose sequel instead.

    class SQL < Base

      def initialize(db_url)
        @db = Sequel.connect(db_url)
      end

      def save(rate)
        @db[:rates].insert_ignore.insert({
          source: rate.source,
          date: rate.date,
          base_currency: rate.base_currency,
          counter_currency: rate.counter_currency,
          rate: rate.rate
        })
      end

      def save_all(rates)
        rate_hashes = rates.map do |rate|
          {
            source: rate.source,
            date: rate.date,
            base_currency: rate.base_currency,
            counter_currency: rate.counter_currency,
            rate: rate.rate
          }
        end

        @db[:rates].insert_ignore.multi_insert(rate_hashes)
      end

      def find(date, base, counter)
        @db[:rates].where(date: date, base_currency: base, counter_currency: counter).map do |r|
          Effex::Rate::Reference.new(r)
        end
      end

      def find_by_counter(date, counter)
        @db[:rates].where(date: date, counter_currency: counter).map do |r|
          Effex::Rate::Reference.new(r)
        end
      end

      def to_s
        "SQL (sequel) repo with #{@db[:rates].count} rates"
      end
    end
  end
end
