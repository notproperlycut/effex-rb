module Effex
  module Repository
    require 'effex/repository/base'
    require 'effex/repository/memory'
    require 'effex/repository/active_record'

    def register(model, repository)
      repositories[model] = repository
    end

    def for(model)      
      repositories[model]
    end

    def repositories
      @repositories ||= {}
    end
  end
end
