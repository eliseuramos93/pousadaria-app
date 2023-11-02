class Inn < ApplicationRecord
  belongs_to :user

  has_one :address
  accepts_nested_attributes_for :address

  has_one :payment_method
  accepts_nested_attributes_for :payment_method

  enum :status, { active: 2, inactive: 0 }
  
  validates :brand_name, :registration_number, :phone_number, :checkin_time,
            :checkout_time, presence: true

  
end
