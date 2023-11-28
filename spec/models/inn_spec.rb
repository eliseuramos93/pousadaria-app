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
      expect(inn.errors.full_messages).to include 'Nome fantasia não pode ficar em branco'
    end

    it 'must have a registration number to be valid' do
      # arrange
      inn = Inn.new

      # act
      inn.valid?
      # assert
      expect(inn.errors.include? :registration_number).to be true
      expect(inn.errors.full_messages).to include 'CNPJ não pode ficar em branco'
    end

    it 'must have a phone number to be valid' do
      # arrange
      inn = Inn.new

      # act
      inn.valid?
      # assert
      expect(inn.errors.include? :phone_number).to be true
      expect(inn.errors.full_messages).to include 'Telefone não pode ficar em branco'
    end

    it 'must have a checkin time to be valid' do
      # arrange
      inn = Inn.new

      # act
      inn.valid?
      # assert
      expect(inn.errors.include? :checkin_time).to be true
      expect(inn.errors.full_messages).to include 'Horário de check-in não pode ficar em branco'
    end

    it 'must have a checkout time to be valid' do
      # arrange
      inn = Inn.new

      # act
      inn.valid?
      # assert
      expect(inn.errors.include? :checkout_time).to be true
      expect(inn.errors.full_messages).to include 'Horário de check-out não pode ficar em branco'
    end
  end

  describe '#calculate_average_rating' do
    it 'returns nil for an inn without reviews' do
      # arrange
      inn = Inn.new
       
      # act
      result = inn.calculate_average_rating

      # assert
      expect(result).to be_nil
    end

    it 'for an inn with one review' do
      # arrange
      user = User.create!(email: 'u@mail.co', password: 'password', role: 'host')
      
      inn = user.build_inn
      inn.save(validate: false)

      room = user.inn.rooms.build
      room.save(validate: false)

      reservation = room.reservations.build
      reservation.save(validate: false)

      review = reservation.create_review!(rating: 4, comment: 'Ok')

      # act
      result = inn.calculate_average_rating

      # assert
      expect(result).to eq 4.0
    end

    it 'for an inn with multiple reviews' do
      # arrange
      user = User.create!(email: 'u@mail.co', password: 'password', role: 'host')
      
      inn = user.build_inn
      inn.save(validate: false)

      room = user.inn.rooms.build
      room.save(validate: false)

      reservation_a = room.reservations.build
      reservation_a.save(validate: false)

      reservation_b = room.reservations.build
      reservation_b.save(validate: false)

      reservation_c = room.reservations.build
      reservation_c.save(validate: false)

      reservation_a.create_review!(rating: 1, comment: 'Bad')
      reservation_b.create_review!(rating: 1, comment: 'Awful!')
      reservation_c.create_review!(rating: 3, comment: 'Okay.')

      # act
      result = inn.calculate_average_rating

      # assert
      expect(result.round(2)).to eq 1.67
    end
  end
end
