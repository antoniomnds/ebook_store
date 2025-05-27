class CreateTaggings < ActiveRecord::Migration[7.2]
  def change
    create_table :taggings do |t|
      t.references :taggable, polymorphic: true, null: false
      t.references :tag, foreign_key: true, null: false

      t.timestamps
    end

    # prevent duplicate taggings
    add_index :taggings, [ :tag_id, :taggable_type, :taggable_id ], unique: true
  end
end
