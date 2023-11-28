class Guest < ApplicationRecord
  belongs_to :checkin
  has_one :reservation, through: :checkin

  validates :full_name, :document, presence: true 
end
