class User < ActiveRecord::Base
  default_scope -> {where deleted: false}
  
  authenticates_with_sorcery!

  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true
  validates :email, presence: true, uniqueness: true
  
  def admin?
    self.role == 'admin'
  end
  
  def user?
    self.role != 'admin'
  end
end
