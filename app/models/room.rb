class Room < ApplicationRecord
  belongs_to :inn
  has_many :seasonal_rates
  has_many :reservations

  validates :name, :description, :area, :max_capacity, :rent_price, presence: true
  
  enum :status, { active: 2, inactive: 0 }

  
  def calculate_rental_price(start_date, end_date)
    return 0 if start_date.blank?
    return 0 if end_date.blank?
    
    rates_hash = generate_rates_hash(start_date, end_date)
    regular_rate_days = calculate_regular_days(start_date, end_date, rates_hash)
    rates_hash[self.rent_price] = regular_rate_days
    calculate_period_price(rates_hash)
  end

  def calculate_checkout_price(reservation)
    checkin_date = reservation.checkin.created_at.utc
    checkout_date = reservation.checkout.created_at.utc

    limit_checkout = Time.new(checkout_date.year, checkout_date.month,
                                  checkout_date.day, self.inn.checkout_time.hour,
                                  self.inn.checkout_time.min, 
                                  self.inn.checkout_time.sec, 0)

    checkout_date += 1.day if checkout_date > limit_checkout

    calculate_rental_price(checkin_date.to_date, checkout_date.to_date)
  end
    
  private

  def generate_rates_hash(start_date, end_date)
    rates_hash = Hash.new(0)

    self.seasonal_rates.each do |rate|
      (start_date..end_date).each do |date|
        if date.to_date.between?(rate.start_date,rate.end_date)
          rates_hash[rate.price] += 1
        end
      end
    end

    rates_hash
  end

  def calculate_regular_days(start_date, end_date, rates_hash)
    regular_days = (end_date - start_date).to_i
    rates_hash.each do |price, days|
      regular_days -= days.to_i
    end
    regular_days
  end

  def calculate_period_price(rates_hash)
    total = 0
    rates_hash.each do |price, days|
      rate_total = price * days
      total += rate_total
    end
    total
  end
end
