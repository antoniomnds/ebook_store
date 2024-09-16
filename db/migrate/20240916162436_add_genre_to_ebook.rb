class AddGenreToEbook < ActiveRecord::Migration[7.2]
  def change
    add_column :ebooks, :genre, :string
  end
end
