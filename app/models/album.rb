class Album < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_many_attached :photos
end
