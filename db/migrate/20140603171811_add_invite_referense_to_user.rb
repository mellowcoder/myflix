class AddInviteReferenseToUser < ActiveRecord::Migration
  def change
    add_column :users, :invite_id, :integer, index: true
  end
end
