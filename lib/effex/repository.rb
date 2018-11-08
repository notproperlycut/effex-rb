module Effex

  # Entrypoint methods for Effex Repository support
  module Repository
    require 'effex/repository/base'
    require 'effex/repository/memory'
    require 'effex/repository/sql'

    # Registers a repository for the supplied model (key)
    #
    # @param model [Symbol] Unique symbol of the model being stored by the repository
    # @param repository [Object] Object implementing the Effex::Repository::Base contract
    def self.register(model, repository)
      repositories[model] = repository
    end

    # Returns a registered repository
    #
    # @param model [Symbol] Unique symbol of the model being stored by the repository
    # @return [Effex::Repository::Base, nil] Requested repository
    def self.for(model)
      repositories[model]
    end

  private
    def self.repositories
      @repositories ||= {}
    end
  end
end
