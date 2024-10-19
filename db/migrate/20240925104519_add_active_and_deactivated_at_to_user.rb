class AddActiveAndDeactivatedAtToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :active, :boolean, default: true
    add_column :users, :deactivated_at, :datetime
  end
end
