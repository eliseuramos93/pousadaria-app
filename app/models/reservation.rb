class Reservation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :room
  has_one :inn, through: :room

  enum status: {pending: 0, confirmed: 2, active: 4, finished: 6, canceled: 8}

  before_validation :generate_code, on: :create
  before_validation :get_reservation_price, on: :create
  
  validates :start_date, :end_date, :number_guests, presence: true
  validates :code, uniqueness: true
  validate :respect_room_max_capacity
  validate :start_date_is_future
  validate :end_date_is_future
  validate :start_date_after_end_date
  validate :no_conflict_with_another_reservation

  def cancel_request_with_seven_or_more_days_ahead?
    return false if self.status == 'active'
    return false if self.status == 'finished'
    return false if self.status == 'canceled'

    if (self.start_date - Date.today).to_i >= 7
      true
    else
      false
    end
  end

  def early_for_checkin
    if (self.start_date - Date.today) > 0
      true
    else
      false
    end
  end

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def get_reservation_price
    return nil unless self.start_date
    return nil unless self.end_date

    self.price = self.room.calculate_total_price(self.start_date, self.end_date)
  end

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

  def has_conflict_with_another_reservation?
    return false if self.room.blank?

    selected_period = (self.start_date..self.end_date)
    other_reservations = self.room.reservations.where.not(status: 'canceled')

    other_reservations.any? do |reservation|
      unless self.id == reservation.id
        reservation_range = (reservation.start_date..reservation.end_date)
        selected_period.overlaps?(reservation_range)
      end
    end
  end

  def start_date_is_future
    return if self.status == 'finished'

    if start_date && start_date.past?
      errors.add(:start_date, :invalid_past_date)
    end
  end

  def end_date_is_future
    return if self.status == 'finished'

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
