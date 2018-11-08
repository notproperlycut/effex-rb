module Effex
  class Log
    def self.log
      return @logger if @logger
      @logger = Logger.new STDOUT
      @logger.info "Created logger"
      @logger
    end
  end
end
