module Effex
  module Repository
    class Base
      def new
        Effex::Rate::Reference.new()
      end

      def save
        raise NotImplementedError, 'Repository must implement save method'
      end

      def save_all(rates)
        rates.each { |r| save(r) }
      end

      def find
        raise NotImplementedError, 'Repository must implement find method'
      end

      def find_by_counter
        raise NotImplementedError, 'Repository must implement find_counter method'
      end
    end
  end
end
