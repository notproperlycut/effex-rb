require 'open-uri'
require 'nokogiri'

module Effex
  module Source
    class EcbXml < Base
      def ecb_url
        raise NotImplementedError, 'ECB XML source must implement the ecb_url method'
      end

      def retrieve
        doc = Nokogiri::XML(open(ecb_url)).remove_namespaces!

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

        decorate(rates)
      end
    end
  end
end
