class User < ActiveRecord::Base
  default_scope where(deleted: false)
  
  authenticates_with_sorcery!
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email  
  validates_uniqueness_of :email
  validates_presence_of :role
  
  def admin?
    self.role == 'admin'
  end
  
  def user?
    self.role != 'admin'
  end
end
