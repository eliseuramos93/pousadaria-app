class Room < ApplicationRecord
  belongs_to :inn
  has_many :seasonal_rates

  enum :status, { active: 2, inactive: 0 }

  validates :name, :description, :area, :max_capacity, :rent_price, presence: true
end
