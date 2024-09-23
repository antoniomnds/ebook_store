class AddUserToEbook < ActiveRecord::Migration[7.2]
  def change
    add_reference :ebooks, :user, null: false, foreign_key: true
  end
end
