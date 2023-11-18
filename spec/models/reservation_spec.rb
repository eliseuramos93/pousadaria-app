require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "#valid?" do
    context 'presence' do
      it 'fails if the mandatory fields are blank or null' do
        # arrange
        reservation = Reservation.new

        # act
        reservation.valid?

        # assert
        expect(reservation.errors.include? :start_date).to be true
        expect(reservation.errors.include? :end_date).to be true
        expect(reservation.errors.include? :number_guests).to be true
      end
    end

    context 'uniqueness' do
      it 'fails if uses an already existing reservation code' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :regular)
        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                              registration_number: '58277983000198', 
                              phone_number: '(11) 976834383', checkin_time: '18:00',
                              checkout_time: '11:00', address_attributes: {
                                street_name: 'Av. da Pousada', number: '10', 
                                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                                state: 'SP', zip_code: '05616-090'})
        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                max_capacity: 2, rent_price: 50, status: :active)
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')
        reservation = room.reservations.create!(start_date: 1.day.from_now,
                                              end_date: 2.days.from_now,
                                              number_guests: '2')
        new_reservation = Reservation.new
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')

        # act
        new_reservation.valid?

        # assert
        expect(new_reservation.errors.include? :code).to be true
      end
    end

    context 'no_conflict_with_another_reservation' do
      it 'that starts during and ends after the selected period' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :regular)
        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                              registration_number: '58277983000198', 
                              phone_number: '(11) 976834383', checkin_time: '18:00',
                              checkout_time: '11:00', address_attributes: {
                                street_name: 'Av. da Pousada', number: '10', 
                                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                                state: 'SP', zip_code: '05616-090'})
        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                max_capacity: 2, rent_price: 50, status: :active)

        reservation = room.reservations.create!(start_date: 10.days.from_now,
                                                end_date: 15.days.from_now,
                                                number_guests: '2',
                                                status: 'confirmed')

        new_reservation = room.reservations.build(start_date: 11.days.from_now,
                                                  end_date: 21.days.from_now,
                                                  number_guests: '1')
        
        # act
        new_reservation.valid?

        # assert
        expect(new_reservation.errors.full_messages)
          .to include 'O quarto já está reservado neste período'
      end

      it 'that starts during and ends during the selected period' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :regular)
        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                              registration_number: '58277983000198', 
                              phone_number: '(11) 976834383', checkin_time: '18:00',
                              checkout_time: '11:00', address_attributes: {
                                street_name: 'Av. da Pousada', number: '10', 
                                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                                state: 'SP', zip_code: '05616-090'})
        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                max_capacity: 2, rent_price: 50, status: :active)

        reservation = room.reservations.create!(start_date: 10.days.from_now,
                                                end_date: 15.days.from_now,
                                                number_guests: '2',
                                                status: 'confirmed')

        new_reservation = room.reservations.build(start_date: 11.days.from_now,
                                                  end_date: 14.days.from_now,
                                                  number_guests: '1')
        
        # act
        new_reservation.valid?

        # assert
        expect(new_reservation.errors.full_messages)
          .to include 'O quarto já está reservado neste período'
      end

      it 'that starts before and ends during the selected period' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :regular)
        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                              registration_number: '58277983000198', 
                              phone_number: '(11) 976834383', checkin_time: '18:00',
                              checkout_time: '11:00', address_attributes: {
                                street_name: 'Av. da Pousada', number: '10', 
                                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                                state: 'SP', zip_code: '05616-090'})
        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                max_capacity: 2, rent_price: 50, status: :active)

        reservation = room.reservations.create!(start_date: 10.days.from_now,
                                                end_date: 15.days.from_now,
                                                number_guests: '2',
                                                status: 'confirmed')

        new_reservation = room.reservations.build(start_date: 9.days.from_now,
                                                  end_date: 11.days.from_now,
                                                  number_guests: '1')
        
        # act
        new_reservation.valid?

        # assert
        expect(new_reservation.errors.full_messages)
          .to include 'O quarto já está reservado neste período'
      end

      it 'that starts before and ends after the selected period' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :regular)
        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                              registration_number: '58277983000198', 
                              phone_number: '(11) 976834383', checkin_time: '18:00',
                              checkout_time: '11:00', address_attributes: {
                                street_name: 'Av. da Pousada', number: '10', 
                                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                                state: 'SP', zip_code: '05616-090'})
        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                max_capacity: 2, rent_price: 50, status: :active)

        reservation = room.reservations.create!(start_date: 10.days.from_now,
                                                end_date: 15.days.from_now,
                                                number_guests: '2',
                                                status: 'confirmed')

        new_reservation = room.reservations.build(start_date: 9.days.from_now,
                                                  end_date: 16.days.from_now,
                                                  number_guests: '1')
        
        # act
        new_reservation.valid?

        # assert
        expect(new_reservation.errors.full_messages)
          .to include 'O quarto já está reservado neste período'
      end

      it 'if the conflicting reservation is not canceled' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :regular)
        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                              registration_number: '58277983000198', 
                              phone_number: '(11) 976834383', checkin_time: '18:00',
                              checkout_time: '11:00', address_attributes: {
                                street_name: 'Av. da Pousada', number: '10', 
                                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                                state: 'SP', zip_code: '05616-090'})
        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                max_capacity: 2, rent_price: 50, status: :active)

        room.reservations.create!(start_date: 8.days.from_now,
                                                end_date: 13.days.from_now,
                                                number_guests: '2',
                                                status: 'canceled')

        new_reservation = room.reservations.build(start_date: 9.days.from_now,
                                                  end_date: 16.days.from_now,
                                                  number_guests: '1')
        
        # act
        new_reservation.valid?

        # assert
        expect(new_reservation.errors.include? :base).to be false
      end
    end

    context 'respect_room_max_capacity' do
      it 'fails due to having more guests than the maximum capacity' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
        role: :regular)
        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                registration_number: '58277983000198', 
                phone_number: '(11) 976834383', checkin_time: '18:00',
                checkout_time: '11:00', address_attributes: {
                  street_name: 'Av. da Pousada', number: '10', 
                  neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                  state: 'SP', zip_code: '05616-090'})
        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                  max_capacity: 2, rent_price: 50, status: :active)

        reservation = room.reservations.build(number_guests: '3')

        # act
        reservation.valid?

        # assert
        expect(reservation.errors.include? :number_guests).to be true
      end
    end

    context 'start_date_is_future and end_date_is_future' do
      it 'fails due to having a start date and/or end date in the past' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
        role: :regular)
        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                registration_number: '58277983000198', 
                phone_number: '(11) 976834383', checkin_time: '18:00',
                checkout_time: '11:00', address_attributes: {
                  street_name: 'Av. da Pousada', number: '10', 
                  neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                  state: 'SP', zip_code: '05616-090'})
        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                  max_capacity: 2, rent_price: 50, status: :active)

        reservation = room.reservations.build(start_date: 2.days.ago,
                                              end_date: 1.day.ago)

        # act
        reservation.valid?

        # assert
        expect(reservation.errors.include? :start_date).to be true
        expect(reservation.errors.include? :end_date).to be true
      end
    end

    context 'start_date_after_end_date' do
      it 'fails due to having a end date before the start date' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
        role: :regular)
        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                registration_number: '58277983000198', 
                phone_number: '(11) 976834383', checkin_time: '18:00',
                checkout_time: '11:00', address_attributes: {
                  street_name: 'Av. da Pousada', number: '10', 
                  neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                  state: 'SP', zip_code: '05616-090'})
        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                  max_capacity: 2, rent_price: 50, status: :active)

        reservation = room.reservations.build(start_date: 5.days.from_now,
                                              end_date: 3.days.from_now)

        # act
        reservation.valid?

        # assert
        expect(reservation.errors.include? :start_date).to be true
      end
    end
  end

  describe "#generate_reservation_code" do
    it 'generates a random code when created' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :regular)
      inn = user.create_inn!(brand_name: 'Pousada Teste', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'})
      room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                              max_capacity: 2, rent_price: 50, status: :active)
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')
      reservation = room.reservations.build(start_date: 1.day.from_now,
                                            end_date: 2.days.from_now,
                                            number_guests: '2')

      # act
      reservation.save

      # assert
      expect(reservation.code).not_to be_empty
      expect(reservation.code).not_to be_nil
      expect(reservation.code.length).to eql 8
    end

    it 'and the code is unique' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :regular)
      inn = user.create_inn!(brand_name: 'Pousada Teste', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'})
      room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                              max_capacity: 2, rent_price: 50, status: :active)
      reservation = room.reservations.create!(start_date: 1.day.from_now,
                                              end_date: 2.days.from_now,
                                              number_guests: '2')
      new_reservation = room.reservations.build(start_date: 3.day.from_now,
                                                end_date: 4.days.from_now,
                                                number_guests: '2')

      # act
      new_reservation.save!

      # assert
      expect(new_reservation.code).not_to eq reservation.code
    end

    it 'and must not be altered' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
      role: :regular)
      inn = user.create_inn!(brand_name: 'Pousada Teste', 
              registration_number: '58277983000198', 
              phone_number: '(11) 976834383', checkin_time: '18:00',
              checkout_time: '11:00', address_attributes: {
                street_name: 'Av. da Pousada', number: '10', 
                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                state: 'SP', zip_code: '05616-090'})
      room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                max_capacity: 2, rent_price: 50, status: :active)
      reservation = room.reservations.create!(start_date: 1.day.from_now,
                                end_date: 2.days.from_now,
                                number_guests: '2')
      original_code = reservation.code

      # act
      reservation.update!(end_date: 3.days.from_now)

      # assert
      expect(reservation.code).to eq original_code
    end
  end

  describe '#guest_cancel_request_with_seven_or_more_days_ahead?' do
    it 'returns false if reservation is active' do
      # arrange
      reservation = Reservation.new(status: 'active')

      # act
      result = reservation.guest_cancel_request_with_seven_or_more_days_ahead?

      # assert
      expect(result).to be false
    end

    it 'returns false if reservation is already finished' do
      # arrange
      reservation = Reservation.new(status: 'finished')

      # act
      result = reservation.guest_cancel_request_with_seven_or_more_days_ahead?

      # assert
      expect(result).to be false
    end

    it 'returns false if reservation is already canceled' do
      # arrange
      reservation = Reservation.new(status: 'canceled')

      # act
      result = reservation.guest_cancel_request_with_seven_or_more_days_ahead?

      # assert
      expect(result).to be false
    end

    it 'returns false if cancelation request is made six days before checkin' do
      # arrange
      reservation = Reservation.new(start_date: 6.days.from_now)

      # act
      result = reservation.guest_cancel_request_with_seven_or_more_days_ahead?

      # assert
      expect(result).to be false
    end

    it 'returns true if cancelation request is made seven days before checkin' do
      # arrange
      reservation = Reservation.new(start_date: 7.days.from_now)

      # act
      result = reservation.guest_cancel_request_with_seven_or_more_days_ahead?

      # assert
      expect(result).to be true
    end

    it 'returns true if cancelation request is made w/ eight or more days before checkin' do
      # arrange
      reservation = Reservation.new(start_date: 8.days.from_now)

      # act
      result = reservation.guest_cancel_request_with_seven_or_more_days_ahead?

      # assert
      expect(result).to be true
    end
  end

  describe '#checkin_within_business_rules?' do
    it 'return false for an active reservation' do
      # arrange
      reservation = Reservation.new(start_date: 0.day.from_now, status: 'active')

      # act
      result = reservation.checkin_within_business_rules?

      # assert
      expect(result).to be false
    end

    it 'return false for a canceled reservation' do
      # arrange
      reservation = Reservation.new(start_date: 0.day.from_now, status: 'canceled')

      # act
      result = reservation.checkin_within_business_rules?

      # assert
      expect(result).to be false
    end

    it 'return false for a finished reservation' do
      # arrange
      reservation = Reservation.new(start_date: 0.day.from_now, status: 'finished')

      # act
      result = reservation.checkin_within_business_rules?

      # assert
      expect(result).to be false
    end

    it 'return false for a checkin in the day before the start date' do
      # arrange
      reservation = Reservation.new(start_date: 1.day.from_now)

      # act
      result = reservation.checkin_within_business_rules?

      # assert
      expect(result).to be false
    end

    it 'return true for a checkin in the start date' do
      # arrange
      reservation = Reservation.new(start_date: 0.day.from_now)

      # act
      result = reservation.checkin_within_business_rules?

      # assert
      expect(result).to be true
    end

    it 'return true for a checkin in the day after the start date' do
      # arrange
      reservation = Reservation.new(start_date: 1.day.ago)

      # act
      result = reservation.checkin_within_business_rules?

      # assert
      expect(result).to be true
    end
  end

  describe '#host_allowed_to_cancel?' do
    it 'returns false for two days after the start date' do
      # arrange
      reservation = Reservation.new(start_date: 2.days.ago)

      # act
      result = reservation.host_allowed_to_cancel?

      # assert
      expect(result).to be false
    end

    it 'returns true for three days after the start date' do
      # arrange
      reservation = Reservation.new(start_date: 3.days.ago)

      # act
      result = reservation.host_allowed_to_cancel?

      # assert
      expect(result).to be true
    end

    it 'returns true for four days after the start date' do
      # arrange
      reservation = Reservation.new(start_date: 4.days.ago)

      # act
      result = reservation.host_allowed_to_cancel?

      # assert
      expect(result).to be true
    end
  end
end
