require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#valid?' do
    it 'must have all of the mandatory fields to be valid' do
      # arrange
      room = Room.new

      # act
      room.valid?

      # assert
      expect(room.errors.include? :name).to be true
      expect(room.errors.include? :description).to be true
      expect(room.errors.include? :area).to be true
      expect(room.errors.include? :max_capacity).to be true
      expect(room.errors.include? :rent_price).to be true
    end
  end

  describe '#calculate_rental_price' do
    it 'calculates the correct price for a rental without seasonal rates' do
      # arrange
      user = User.create!(email: 'u@mail.co', password: 'password', role: 'host')
      
      inn = user.build_inn
      inn.save(validate: false) 
      
      room = inn.rooms.build(rent_price: 100.00)
      room.save(validate: false)
      
      # act
      start_date = 0.days.from_now.to_date
      end_date = 10.days.from_now.to_date

      total_price = room.calculate_rental_price(start_date, end_date)

      # assert
      expect(total_price).to eq 1000.0
    end

    it 'calculates the correct price with a seasonal rate' do
      # arrange
      user = User.create!(email: 'u@mail.co', password: 'password', role: 'host')
      
      inn = user.build_inn
      inn.save(validate: false) 
      
      room = inn.rooms.build(rent_price: 100.00)
      room.save(validate: false)

      room.seasonal_rates.create(start_date: 5.days.from_now, end_date: 10.days.from_now, price: 200)
      
      # act
      start_date = 0.days.from_now.to_date
      end_date = 10.days.from_now.to_date

      total_price = room.calculate_rental_price(start_date, end_date)

      # assert
      expect(total_price).to eq 1500.0
    end
  end
end
