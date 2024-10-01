class CreateEbookTags < ActiveRecord::Migration[7.2]
  def change
    create_table :ebook_tags do |t|
      t.references :ebook, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
