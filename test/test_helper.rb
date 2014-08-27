# add gem lib dir to the load path...
$:.unshift File.expand_path("../lib", File.dirname(__FILE__))


# setup minitest
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

# setup database and models
require 'db/setup'

# require the gem
require 'omniauth_service'

OmniauthService.configure do |config|
  config.user_attributes = Proc.new { |omniauth|
    {
      :first_name => omniauth["info"]["first_name"],
      :last_name  => omniauth["info"]["last_name"],
      :full_name  => omniauth["info"]["name"]
    }
  }
  config.valid_google_domains = ["voxmedia.com"]
end
