class CreatePurchases < ActiveRecord::Migration[7.2]
  def change
    create_table :purchases do |t|
      t.datetime :purchased_at
      t.decimal :price, precision: 5, scale: 2
      t.references :buyer, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.references :ebook, null: false, foreign_key: true

      t.timestamps
    end
  end
end
