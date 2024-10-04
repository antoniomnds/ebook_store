class CreateEbooks < ActiveRecord::Migration[7.2]
  def change
    create_table :ebooks do |t|
      t.string :title
      t.integer :status
      t.decimal :price, precision: 5, scale: 2
      t.string :authors
      t.string :publisher
      t.datetime :publication_date
      t.integer :pages
      t.string :isbn, index: { unique: true }
      t.integer :sales, default: 0
      t.integer :views, default: 0
      t.integer :preview_downloads, default: 0

      t.timestamps
    end
  end
end
