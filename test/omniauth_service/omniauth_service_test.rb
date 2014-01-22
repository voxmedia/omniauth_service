require_relative '../test_helper'

def create_omniauth
  return {
    'provider' => 'google_oauth2',
    'uid'      => '9895b74812e6496b',
    'credentials' => {
      'token'  => '7173CFC6-E9A3-4CDD-8E29-1914D9E10ED8',
      'secret' => '590D12EE-8813-45C6-897B-4D5B64CA2801'
    },
    'info' => {
      'email'      => 'canned-ham@voxmedia.com',
      'nickname'   => 'canned-ham',
      'name'       => 'Canned Ham',
      'first_name' => 'Canned',
      'last_name'  => 'Ham',
      'image'      => 'http://i.walmartimages.com/i/p/00/07/08/92/18/0007089218812_215X215.jpg',
      'urls' => {
        'Google' => 'https://plus.google.com/114916754338815630954'
      }
    }
  }
end

def create_user
  return User.create({
    :email      => "canned-ham@voxmedia.com",
    :full_name  => "Ham Rove",
    :first_name => "Ham",
    :last_name  => "Rove"
  })
end

def create_authorization(user)
  return user.authorizations.create!({ :provider => 'google_oauth2', :uid => '9895b74812e6496b' })
end

def assert_authorization_properties(authorization)
  assert_equal true, authorization.persisted?
  assert_equal "google_oauth2", authorization.provider
  assert_equal "9895b74812e6496b", authorization.uid
  assert_equal "7173CFC6-E9A3-4CDD-8E29-1914D9E10ED8", authorization.token
  assert_equal "590D12EE-8813-45C6-897B-4D5B64CA2801", authorization.secret
  assert_equal "Canned Ham", authorization.name
  assert_equal "canned-ham", authorization.nickname
  assert_equal "http://i.walmartimages.com/i/p/00/07/08/92/18/0007089218812_215X215.jpg", authorization.image
  assert_equal "https://plus.google.com/114916754338815630954", authorization.link
end




describe OmniauthService do

  it "unauthenticated user without existing authorization" do
    @omniauth = create_omniauth
    authorization = OmniauthService.authorize(@omniauth, nil)
    assert_authorization_properties authorization
    assert_equal true, authorization.user.persisted?
    assert_equal "canned-ham@voxmedia.com", authorization.user.email
    assert_equal "Canned Ham", authorization.user.full_name
    assert_equal "Canned", authorization.user.first_name
    assert_equal "Ham", authorization.user.last_name
  end
  
  it "unauthenticated user with existing authorization" do
    @omniauth      = create_omniauth
    @user          = create_user
    @authorization = create_authorization(@user)
    authorization = OmniauthService.authorize(@omniauth, nil)
    assert_authorization_properties authorization
    assert_equal @authorization, authorization
    assert_equal @user, authorization.user
    assert_equal "Ham Rove", authorization.user.full_name, "Should not have touched existing user property"
    assert_equal "Ham", authorization.user.first_name, "Should not have touched existing user property"
    assert_equal "Rove", authorization.user.last_name, "Should not have touched existing user property"
  end

  it "authenticated user without existing authorization" do
    @omniauth = create_omniauth
    @user     = create_user
    authorization = OmniauthService.authorize(@omniauth, @user)
    assert_authorization_properties authorization
    assert_equal @user, authorization.user
  end

  it "authenticated user with existing authorization" do
    @omniauth      = create_omniauth
    @user          = create_user
    @authorization = create_authorization(@user)
    authorization = OmniauthService.authorize(@omniauth, @user)
    assert_authorization_properties authorization
    assert_equal @authorization, authorization
    assert_equal @user, authorization.user
  end

  it "authenticated user with someone else's authorization" do
    @omniauth      = create_omniauth
    @user          = create_user
    @authorization = create_authorization(@user)
    @evil_user = User.create({
      :email      => "evil-user@voxmedia.com",
      :full_name  => "Evil User",
      :first_name => "Evil",
      :last_name  => "User"
    })
    assert_raises(OmniauthService::AuthorizationError) {
      OmniauthService.authorize(@omniauth, @evil_user)
    }
  end


  it "validating unknown provider" do
    assert_raises(OmniauthService::AuthorizationError) {
      OmniauthService.validate!('provider' => 'ham')
    }
  end

  it "validating google_oauth2" do
    OmniauthService.validate!('provider' => 'google_oauth2', 'info' => { 'email' => "personcat@voxmedia.com" })
    OmniauthService.validate!('provider' => 'google_oauth2', 'info' => { 'email' => "personcat@sbnation.com" })
    OmniauthService.validate!('provider' => 'google_oauth2', 'info' => { 'email' => "personcat@theverge.com" })
    OmniauthService.validate!('provider' => 'google_oauth2', 'info' => { 'email' => "personcat@polygon.com"  })
    assert_raises(OmniauthService::AuthorizationError) {
      OmniauthService.validate!('provider' => 'google_oauth2', 'info' => { 'email' => "personcat@evil.com" })
    }
  end

end
