module Effex
  module Source
    class Ecb90Day < EcbXml
      def ecb_url
        "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"
      end

      def source_name
        "ecb-xml-90-day-v1"
      end
    end
  end
end
