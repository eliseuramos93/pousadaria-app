class Review < ApplicationRecord
  belongs_to :reservation
  has_one :user, through: :reservation

  validates :rating, :comment, presence: true
end
