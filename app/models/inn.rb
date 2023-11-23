class Inn < ApplicationRecord
  belongs_to :user
  
  has_one :address
  has_one :payment_method
  has_many :rooms
  has_many :reservations, through: :rooms
  has_many :reviews, through: :reservations

  accepts_nested_attributes_for :payment_method
  accepts_nested_attributes_for :address

  validates :brand_name, :registration_number, :phone_number, :checkin_time,
            :checkout_time, presence: true 

  enum :status, { active: 2, inactive: 0 }

  def calculate_average_rating
    return self.reviews.average('rating') if self.reviews.present?
  end

  def generate_show_inn_json
    average_rating = self.generate_average_rating_json

    inn_json = self.as_json(
      include: { 
        address: { 
          except: [:id, :inn_id, :created_at, :updated_at]}},
      except: [:created_at, :updated_at, :user_id, :registration_number])

    inn_json.merge!(average_rating: average_rating)
  end

  def generate_average_rating_json
    return '' if self.calculate_average_rating.blank?

    self.calculate_average_rating.to_f
  end
end
