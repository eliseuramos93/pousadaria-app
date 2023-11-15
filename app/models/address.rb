class Address < ApplicationRecord
  # relationships
  belongs_to :inn
  
  # validations
  validates :street_name, :number, :neighborhood, :city, :state, :zip_code,
            presence: true

  def formatted_neighborhood_city_state
    "#{self.neighborhood}, #{self.city} - #{self.state}"
  end
end
