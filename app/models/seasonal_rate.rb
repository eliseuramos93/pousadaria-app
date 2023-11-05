class SeasonalRate < ApplicationRecord
  belongs_to :room
  validates :start_date, :end_date, :price, presence: true
  validate :end_date_greater_or_equal_to_start_date
  validate :start_date_is_future
  validate :has_no_conflict_with_another_seasonal_rate

  def has_conflict_with_another_seasonal_rate?
    return false if self.room.nil?
    
    self_range = (self.start_date..self.end_date)

    self.room.seasonal_rates.any? do |rate|
      unless rate.id == self.id
        rate_range = (rate.start_date..rate.end_date)
        self_range.overlaps? rate_range
      end
    end
  end

  private

  def end_date_greater_or_equal_to_start_date
    if (start_date.present? && end_date.present?) && (end_date < start_date)
      errors.add(:end_date, :end_before_start)
    end
  end

  def start_date_is_future
    if start_date.present? && start_date.past?
      errors.add(:start_date, :start_date_on_past)
    end
  end

  def has_no_conflict_with_another_seasonal_rate
    if self.has_conflict_with_another_seasonal_rate?
      errors.add(:base, :conflict_with_another_object)
    end
  end
end
