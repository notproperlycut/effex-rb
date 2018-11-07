require 'effex/repository'

module Effex
  module Source
    class Base
      def retrieve
        raise NotImplementedError, 'Source must implement the retrieve method'
      end
    end
  end
end
