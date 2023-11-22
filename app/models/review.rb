class Review < ApplicationRecord
  belongs_to :reservation
  has_one :user, through: :reservation
  has_one :host_reply

  validates :rating, :comment, presence: true
end
