class Authorization < ActiveRecord::Base
  belongs_to :user
end

class User < ActiveRecord::Base
  has_many :authorizations, :dependent => :destroy
end
