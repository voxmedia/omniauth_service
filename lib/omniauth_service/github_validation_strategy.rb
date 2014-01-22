module OmniauthService
  class GithubValidationStrategy < ValidationStrategy

    def validate!
      raise AuthorizationError.new "Unauthorized Github user." unless valid?
    end

    def valid?
      # TODO: verify username is in voxmedia github organization
      true
    end

  end
end
