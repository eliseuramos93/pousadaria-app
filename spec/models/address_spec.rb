require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid?' do
    it 'must have a street name to be valid' do
      # arrange
      address = Address.new

      # act
      address.valid?

      # assert
      expect(address.errors.include? :street_name).to be true
    end

    it 'must have a number to be valid' do
      # arrange
      address = Address.new

      # act
      address.valid?

      # assert
      expect(address.errors.include? :number).to be true
    end

    it 'is not mandatory to have a complement to be valid' do
      # arrange
      address = Address.new

      # act
      address.valid?

      # assert
      expect(address.errors.include? :complement).to be false
    end
    
    it 'must have a neighborhood to be valid' do
      # arrange
      address = Address.new

      # act
      address.valid?

      # assert
      expect(address.errors.include? :neighborhood).to be true
    end

    it 'must have a city to be valid' do
      # arrange
      address = Address.new

      # act
      address.valid?

      # assert
      expect(address.errors.include? :city).to be true
    end

    it 'must have a state to be valid' do
      # arrange
      address = Address.new

      # act
      address.valid?

      # assert
      expect(address.errors.include? :state).to be true
    end

    it 'must have a zip code to be valid' do
      # arrange
      address = Address.new

      # act
      address.valid?

      # assert
      expect(address.errors.include? :zip_code).to be true
    end
  end

  describe '#formatted_neighborhood_city_state' do
    it 'displays neighborhood, city and state concatenated' do
      # arrange
      address = Address.new(neighborhood: 'Itaquera', city: 'São Paulo',
                            state: 'SP')

      # act
      result = address.formatted_neighborhood_city_state

      # assert
      expect(result).to eq 'Itaquera, São Paulo - SP'
    end
  end
end
