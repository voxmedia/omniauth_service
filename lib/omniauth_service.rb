require "omniauth_service/configuration"
require "omniauth_service/errors"
require "omniauth_service/version"

require "omniauth_service/validation_strategy"
require "omniauth_service/github_validation_strategy"
require "omniauth_service/google_validation_strategy"


module OmniauthService

  def self.configure
    yield(self.configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end


  def self.authorize(omniauth, user = nil)
    raise ArgumentError.new "provider and uid fields are required" unless (omniauth['provider'] && omniauth['uid'])
    self.validate!(omniauth)
    
    authorization = self.resolve_authorization(omniauth)
    if authorization
      # existing authorization found, update it w/ values from omniauth
      if user && user != authorization.user
        raise AuthorizationError.new "Account in use by another user!"
      else
        authorization.update_attributes!(self.authorization_hash(omniauth))
      end
    else
      # new provider/uid combo, resolve the user and create a new authorization
      user ||= self.resolve_user(omniauth)
      authorization = user.authorizations.create!(self.authorization_hash(omniauth))
    end
    return authorization
  end


  def self.validate!(omniauth)
    self.validation_strategy_for(omniauth).validate!
  end

  def self.validation_strategy_for(omniauth)
    case omniauth['provider']
    when 'google_oauth2'
      GoogleValidationStrategy.new(omniauth)
    when 'github'
      GithubValidationStrategy.new(omniauth)
    else
      ValidationStrategy.new(omniauth)
    end
  end


  def self.resolve_user(omniauth)
    email = omniauth["info"]["email"]
    # TODO: deal with providers that don't send email (cough... twitter).
    raise ArgumentError.new "Email required" unless email
    attributes = self.configuration.user_attributes.call(omniauth)
    user = User.where({ :email => email }).first_or_create!(attributes)
    return user
  end

  def self.resolve_authorization(omniauth)
    authorization = Authorization.where({ :provider => omniauth['provider'], :uid => omniauth['uid'] }).first
    if authorization && authorization.user.nil?
      # this should never happen because the user model has :dependent => :destroy, but... Safety First™
      authorization.destroy
      authorization = nil
    end
    return authorization
  end

  def self.authorization_hash(omniauth)
    hash = {
      :provider       => omniauth['provider'],
      :uid            => omniauth['uid'],
      :token          => omniauth['credentials']['token'],
      :secret         => omniauth['credentials']['secret'],
      :refresh_token  => omniauth['credentials']['refresh_token'],
      :expires        => omniauth['credentials']['expires'],
      :expires_at     => omniauth['credentials']['expires_at']
    }

    # optional params not always returned by every provider...
    hash[:name]      = omniauth['info']['name']      if omniauth['info']['name']
    hash[:nickname]  = omniauth['info']['nickname']  if omniauth['info']['nickname']
    hash[:image]     = omniauth['info']['image']     if omniauth['info']['image']
    # the profile link can be hiding in a few places...
    url_key       = self.url_key_for_provider(omniauth['provider'])
    urls_hash     = (omniauth['info']['urls'] || {})
    raw_info_hash = ((omniauth['extra'] || {})['raw_info'] || {})
    if urls_hash[url_key]
      hash[:link] = urls_hash[url_key]
    elsif raw_info_hash['link']
      hash[:link] = raw_info_hash['link']
    end

    return hash
  end

  def self.url_key_for_provider(provider)
    case provider
    when "github"
      "GitHub"
    else
      provider.split("_").first.to_s.titleize
    end
  end

end
