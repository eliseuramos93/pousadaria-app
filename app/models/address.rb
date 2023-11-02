class Address < ApplicationRecord
  belongs_to :inn
  
  validates :street_name, :number, :neighborhood, :city, :state, :zip_code,
            presence: true

  def formatted_neighborhood_city_state
    "#{self.neighborhood}, #{self.city} - #{self.state}"
  end
end
