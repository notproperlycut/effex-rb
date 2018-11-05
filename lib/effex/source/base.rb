require 'effex/repository'

module Effex
  module Source
    class Base
      def retrieve
        raise NotImplementedError, 'Source must implement the retrieve method'
      end

      def retrieve_and_save
        retrieve.each { |r| Effex::Repository.for(:reference_rate).save(r) }
      end
    end
  end
end
