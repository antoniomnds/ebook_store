class CreateBuyers < ActiveRecord::Migration[7.2]
  def change
    create_table :buyers do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
