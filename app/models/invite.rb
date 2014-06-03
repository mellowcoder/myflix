class Invite < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :email, :name, :message, :user
  
  include Tokened

end
