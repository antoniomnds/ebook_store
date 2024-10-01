class AddUserToEbook < ActiveRecord::Migration[7.2]
  def change
    add_reference :ebooks, :user, foreign_key: true
  end
end
