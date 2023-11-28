class Consumable < ApplicationRecord
  belongs_to :reservation

  validates :description, :price, presence: true
end
