module Effex
  module Repository
    class Base
      def new
        Effex::Rate::Reference.new()
      end

      def save
        raise NotImplementedError, 'Repository must implement save method'
      end

      def find_by_date
        raise NotImplementedError, 'Repository must implement find_by_date method'
      end
    end
  end
end
