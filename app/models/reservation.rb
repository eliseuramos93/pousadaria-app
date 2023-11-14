class Reservation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :room
  has_one :inn, through: :room
  
  enum status: {pending: 0, confirmed: 2, active: 4, finished: 6, canceled: 8}
  
  validates :start_date, :end_date, :number_guests, presence: true
  validate :respect_room_max_capacity
  validate :start_date_is_future
  validate :end_date_is_future
  validate :start_date_after_end_date
  validate :no_conflict_with_another_reservation

  def has_conflict_with_another_reservation?
    return false if self.room.nil?

    selected_period = (self.start_date..self.end_date)

    self.room.reservations.any? do |reservation|
      unless self.id == reservation.id
        reservation_range = (reservation.start_date..reservation.end_date)
        selected_period.overlaps?(reservation_range)
      end
    end
  end

  private

  def respect_room_max_capacity
    if number_guests && number_guests > self.room.max_capacity
      errors.add(:number_guests, :guests_over_capacity)
    end
  end

  def no_conflict_with_another_reservation
    if self.has_conflict_with_another_reservation?
      errors.add(:base, :conflict_with_another_reservation)
    end
  end

  def start_date_is_future
    if start_date && start_date.past?
      errors.add(:start_date, :invalid_past_date)
    end
  end

  def end_date_is_future
    if end_date && end_date.past?
      errors.add(:end_date, :invalid_past_date)
    end
  end

  def start_date_after_end_date
    if (start_date && end_date) && start_date > end_date
      errors.add(:start_date, :invalid_start_date_future)
    end
  end
end
