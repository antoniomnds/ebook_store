class CreateBuyerEbooks < ActiveRecord::Migration[7.2]
  def change
    create_table :ebook_buyers do |t|
      t.references :buyer, null: false, foreign_key: true
      t.references :ebook, null: false, foreign_key: true

      t.timestamps
    end
  end
end
