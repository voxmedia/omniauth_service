module OmniauthService
  class Configuration

    attr_writer :user_attributes

    def user_attributes
      @user_attributes ||= Proc.new { |omniauth|
        {
          :first_name => omniauth["info"]["first_name"],
          :last_name  => omniauth["info"]["last_name"]
        }
      }
    end

  end
end
