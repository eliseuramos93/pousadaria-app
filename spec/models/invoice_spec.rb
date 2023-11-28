require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "#calculate_total_reservation_price" do
    it 'does not add an extra daily rate if checkout before limit hour' do
      # arrange
      user = User.create!(email: 'billy@mail.com', password: 'password', role: 'host')

      inn = user.build_inn(checkout_time: '13:00')
      inn.save(validate: false)

      room = inn.rooms.build(rent_price: 19.90)
      room.save(validate: false)

      reservation = room.reservations.build(start_date: 1.day.from_now)    
      reservation.save(validate: false)

      travel_to 1.day.from_now.midday do
        reservation.build_checkin.save(validate: false)
      end

      travel_to 3.days.from_now.midday do
        reservation.build_checkout(payment_method: 'cash').save(validate: false)
        reservation.create_invoice
      end

      # act
      total_price = reservation.invoice.calculate_total_reservation_price

      # assert
      expect(total_price).to eq 39.80
    end

    it 'add an extra daily rate if checkout is after limit hour' do
      # arrange
      user = User.create!(email: 'billy@mail.com', password: 'password', role: 'host')

      inn = user.build_inn(checkout_time: '13:00')
      inn.save(validate: false)

      room = inn.rooms.build(rent_price: 19.90)
      room.save(validate: false)

      reservation = room.reservations.build(start_date: 1.day.from_now)    
      reservation.save(validate: false)

      travel_to 1.day.from_now.midday do
        reservation.build_checkin.save(validate: false)
      end

      travel_to 2.days.from_now.at_end_of_day do
        reservation.build_checkout(payment_method: 'cash').save(validate: false)
        reservation.create_invoice
      end

      # act
      total_price = reservation.invoice.calculate_total_reservation_price

      # assert
      expect(total_price).to eq 39.80
    end

    it 'calculate a correct price adding the consumables' do
      # arrange
      user = User.create!(email: 'billy@mail.com', password: 'password', role: 'host')

      inn = user.build_inn(checkout_time: '13:00')
      inn.save(validate: false)

      room = inn.rooms.build(rent_price: 19.90)
      room.save(validate: false)

      reservation = room.reservations.build(start_date: 1.day.from_now)    
      reservation.save(validate: false)

      travel_to 1.day.from_now.midday do
        reservation.build_checkin.save(validate: false)
      end

      reservation.consumables.create(description: 'Adicional limpeza', price: 100)

      travel_to 2.days.from_now.midday do
        reservation.build_checkout(payment_method: 'cash').save(validate: false)
        reservation.create_invoice
      end

      # act
      total_price = reservation.invoice.calculate_total_reservation_price

      # assert
      expect(total_price).to eq 119.90
    end
  end
end