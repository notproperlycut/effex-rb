require 'open-uri'
require 'nokogiri'

module Effex
  module Source
    class EcbXml < Base
      def ecb_url
        raise NotImplementedError, 'ECB XML source must implement the ecb_url method'
      end

      def retrieve
        doc = Nokogiri::Slop(open(ecb_url))
        rates = doc.html.body.envelope.cube.cube.flat_map do |date_collection|
          date_collection.cube.map do |rate|
            {
              date: date_collection["time"],
              counter_currency: rate["currency"],
              base_currency: "EUR",
              rate: rate["rate"]
            }
          end
        end

        decorate(rates)
      end
    end
  end
end
