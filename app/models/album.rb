class Album < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_many_attached :photos

  validates :photos, content_type: ['image/png', 'image/jpeg', 'image/jpg']
end
