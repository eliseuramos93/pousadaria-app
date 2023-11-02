require 'rails_helper'

RSpec.describe Inn, type: :model do
  describe '#valid' do 
    it 'must have a brand name to be valid' do
      # arrange
      inn = Inn.new

      # act
      inn.valid?
      # assert
      expect(inn.errors.include? :brand_name).to be true
    end

    it 'must have a registration number to be valid' do
      # arrange
      inn = Inn.new

      # act
      inn.valid?
      # assert
      expect(inn.errors.include? :registration_number).to be true
    end

    it 'must have a phone number to be valid' do
      # arrange
      inn = Inn.new

      # act
      inn.valid?
      # assert
      expect(inn.errors.include? :phone_number).to be true
    end

    it 'must have a checkin time to be valid' do
      # arrange
      inn = Inn.new

      # act
      inn.valid?
      # assert
      expect(inn.errors.include? :checkin_time).to be true
    end

    it 'must have a checkout time to be valid' do
      # arrange
      inn = Inn.new

      # act
      inn.valid?
      # assert
      expect(inn.errors.include? :checkout_time).to be true
    end
  end
end
