module Effex
  module Repository
    require 'effex/repository/base'
    require 'effex/repository/memory'
    require 'effex/repository/active_record'

    def self.register(model, repository)
      repositories[model] = repository
    end

    def self.for(model)
      repositories[model]
    end

    def self.repositories
      @repositories ||= {}
    end
  end
end
