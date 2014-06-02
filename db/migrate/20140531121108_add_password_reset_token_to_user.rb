class AddPasswordResetTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_reset_token, :string, index: true
  end
end
