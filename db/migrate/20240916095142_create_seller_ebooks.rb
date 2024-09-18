class CreateSellerEbooks < ActiveRecord::Migration[7.2]
  def change
    create_table :ebook_sellers do |t|
      t.references :seller, null: false, foreign_key: true
      t.references :ebook, null: false, foreign_key: true

      t.timestamps
    end
  end
end
