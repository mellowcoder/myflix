class Invite < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :email, :name, :user
  
  before_create :generate_token
  
  private 
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
  
end
