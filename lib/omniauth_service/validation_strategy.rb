module OmniauthService
  class ValidationStrategy

    attr_accessor :omniauth

    def initialize(omniauth)
      @omniauth = omniauth
    end

    def validate!
      raise AuthorizationError.new "Unauthorized identity provider."
    end

  end
end
