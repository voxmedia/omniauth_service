module OmniauthService
  class GoogleValidationStrategy < ValidationStrategy

    def validate!
      raise AuthorizationError.new "Unauthorized Google Apps domain." unless valid?
    end

    def valid?
      email = omniauth['info'] && omniauth['info']['email']
      return email.to_s.end_with?(*valid_domains)
    end

    def valid_domains
      ["voxmedia.com", "sbnation.com", "theverge.com", "polygon.com"]
    end

  end
end
