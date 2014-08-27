module OmniauthService
  class GoogleValidationStrategy < ValidationStrategy

    def validate!
      raise AuthorizationError.new "Unauthorized Google Apps domain." unless valid?
    end

    def valid?
      email = omniauth['info'] && omniauth['info']['email']
      substrings = OmniauthService.configuration.valid_google_domains.map { |domain| "@#{domain}" }
      return email.to_s.end_with?(*substrings)
    end

  end
end
