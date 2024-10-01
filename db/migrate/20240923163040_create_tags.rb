class CreateTags < ActiveRecord::Migration[7.2]
  def change
    create_table :tags do |t|
      t.string :name, index: { unique: true }
      t.string :description

      t.timestamps
    end
  end
end
