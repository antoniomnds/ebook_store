class AddPasswordExpiresAtToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :password_expires_at, :datetime
  end
end
