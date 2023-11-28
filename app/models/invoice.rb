class Invoice < ApplicationRecord
  belongs_to :reservation
  has_one :room, through: :reservation
  has_one :inn, through: :reservation
  has_many :consumables, through: :reservation

  def calculate_total_reservation_price
    rental_total = self.calculate_post_checkout_rental_price
    consumables_total = self.calculate_post_checkout_consumables_price
    
    reservation_total = rental_total + consumables_total
  end 

  private 

  def calculate_post_checkout_rental_price
    checkin_date = self.reservation.checkin.created_at
    checkout_date = self.reservation.checkout.created_at

    limit_checkout = Time.new(checkout_date.year, checkout_date.month,
                                  checkout_date.day, self.inn.checkout_time.hour,
                                  self.inn.checkout_time.min, 
                                  self.inn.checkout_time.sec)

    checkout_date += 1.day if checkout_date > limit_checkout

    self.room.calculate_rental_price(checkin_date.to_date, checkout_date.to_date)
  end

  def calculate_post_checkout_consumables_price
    return 0 if self.consumables.blank?
    
    consumables_total = 0
    self.consumables.each do |consumable|
      consumables_total += consumable.price
    end

    consumables_total
  end
end
