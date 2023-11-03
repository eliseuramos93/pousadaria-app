class SeasonalRate < ApplicationRecord
  belongs_to :room
  validates :start_date, :end_date, :price, presence: true
end
