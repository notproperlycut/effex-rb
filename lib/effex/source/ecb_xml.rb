require 'open-uri'
require 'nokogiri'

module Effex
  module Source
    # Assumption here that all the ECB XML feeds, conform to the same schema
    class EcbXml < Base
      def initialize(ecb_urls)
        @ecb_urls = ecb_urls.split(',')
      end

      def retrieve
        @ecb_urls.flat_map { |url| retrieve_one(url) }
      end

      def retrieve_one(url)
        doc = Nokogiri::XML(open(url)).remove_namespaces!

        rates = doc.xpath("/Envelope/Cube/Cube").flat_map do |date_collection|
          date_collection.xpath("Cube").map do |rate|
            {
              date: date_collection.attribute("time").value,
              base_currency: "EUR",
              counter_currency: rate.attribute("currency").value,
              rate: rate.attribute("rate").value
            }
          end
        end

        decorate(rates, url)
      end
    end
  end
end
