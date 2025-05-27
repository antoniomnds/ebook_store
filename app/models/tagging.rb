class Tagging < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tag

  validates :tag_id,
           uniqueness: {
             scope: [ :taggable_type, :taggable_id ],
             message: "Can't tag the same taggable twice with the same tag"
           }
end
