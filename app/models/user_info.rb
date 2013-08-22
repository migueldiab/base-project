class UserInfo < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true, on: :update # Creation is held by the User model

end
