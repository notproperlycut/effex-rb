require 'effex/rate/base'
require 'active_model'
require 'validates_timeliness'

# TODO: rate should be stored as a string (the exact string supplied)

module Effex
  module Rate
    class Reference < Base
      include ActiveModel::Validations

      attr_accessor :date, :base_currency, :counter_currency, :rate

      validates_date :date, presence: true
      validates :base_currency, presence: true, format: { with: /[A-Z][A-Z][A-Z]/, message: "Incorrect currency format" }
      validates :counter_currency, presence: true, format: { with: /[A-Z][A-Z][A-Z]/, message: "Incorrect currency format" }
      validates :rate, presence: true, numericality: { greater_than: 0.0 }
      validate :currencies_cannot_be_equal

      def initialize(attribs)
        attribs.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end

        @date = Date.parse("#{@date}") if valid?
      end

      def currencies_cannot_be_equal
        errors.add(:counter_currency, "Cannot be the same as base currency") if @counter_currency == @base_currency
      end
    end
  end
end
