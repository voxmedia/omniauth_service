module OmniauthService
  class Configuration

    attr_writer :user_attributes, :valid_google_domains

    def user_attributes
      @user_attributes ||= Proc.new { |omniauth|
        {
          :first_name => omniauth["info"]["first_name"],
          :last_name  => omniauth["info"]["last_name"]
        }
      }
    end

    def valid_google_domains
      @valid_google_domains ||= []
    end

  end
end
