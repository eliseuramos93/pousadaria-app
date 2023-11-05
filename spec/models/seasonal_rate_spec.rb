require 'rails_helper'

RSpec.describe SeasonalRate, type: :model do
  describe '#valid' do
    it 'only if a start date, end date and price are present' do
      # arrange
      seasonal_rate = SeasonalRate.new

      # act
      seasonal_rate.valid?

      # assert
      expect(seasonal_rate.errors.include? :start_date).to be true
      expect(seasonal_rate.errors.include? :end_date).to be true
      expect(seasonal_rate.errors.include? :price).to be true
    end

    it 'if the end date is equal to the start date' do
      # arrange
      seasonal_rate = SeasonalRate.new(start_date: 1.day.from_now, 
                                       end_date: 1.day.from_now)

      # act
      seasonal_rate.valid?

      # assert
      expect(seasonal_rate.errors.include? :end_date).to be false
    end

    it 'if the end date is greater than the start date' do
      # arrange
      seasonal_rate = SeasonalRate.new(start_date: 1.day.from_now, 
                                       end_date: 2.days.from_now)

      # act
      seasonal_rate.valid?

      # assert
      expect(seasonal_rate.errors.include? :end_date).to be false
    end

    it 'fails if the end date is lower than the start date' do
      # arrange
      seasonal_rate = SeasonalRate.new(start_date: 1.day.from_now, 
                                       end_date: 0.day.from_now)

      # act
      seasonal_rate.valid?

      # assert
      expect(seasonal_rate.errors.include? :end_date).to be true
    end

    it 'fails if the start date is past' do
      # arrange
      seasonal_rate = SeasonalRate.new(start_date: 1.day.ago)

      # act
      seasonal_rate.valid?

      # assert
      expect(seasonal_rate.errors.include? :start_date).to be true
    end

    context 'fails due to period conflict with another seasonal rate' do
      it 'when the last day of the created rate conflicts with the first of an existing one' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :host)

        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                           street_name: 'Av. da Pousada', number: '10', 
                           neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                           state: 'SP', zip_code: '05616-090'}, status: :active)

        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                 max_capacity: 2, rent_price: 50, 
                                 status: :active)

        room.seasonal_rates.create!(start_date: 10.days.from_now,
                                          end_date: 11.days.from_now,
                                          price: '60.99')

        rate = room.seasonal_rates.build(start_date: 1.day.from_now,
                                         end_date: 10.days.from_now)

        # act
        rate.valid?

        # assert
        expect(rate.errors.full_messages).to include 'Preço de Temporada não pode ter conflito de datas com outros Preços de Temporadas'
      end

      it 'when the first day of the created rate conflicts with the last of an existing one' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :host)

        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                           street_name: 'Av. da Pousada', number: '10', 
                           neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                           state: 'SP', zip_code: '05616-090'}, status: :active)

        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                 max_capacity: 2, rent_price: 50, 
                                 status: :active)

        room.seasonal_rates.create!(start_date: 10.days.from_now,
                                          end_date: 11.days.from_now,
                                          price: '60.99')

        rate = room.seasonal_rates.build(start_date: 11.day.from_now,
                                         end_date: 100.days.from_now)

        # act
        rate.valid?

        # assert
        expect(rate.errors.full_messages).to include 'Preço de Temporada não pode ter conflito de datas com outros Preços de Temporadas'
      end

      it 'when the entire period is inside of an existing rate' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :host)

        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                           street_name: 'Av. da Pousada', number: '10', 
                           neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                           state: 'SP', zip_code: '05616-090'}, status: :active)

        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                 max_capacity: 2, rent_price: 50, 
                                 status: :active)

        room.seasonal_rates.create!(start_date: 10.days.from_now,
                                          end_date: 20.days.from_now,
                                          price: '60.99')

        rate = room.seasonal_rates.build(start_date: 11.day.from_now,
                                         end_date: 19.days.from_now)

        # act
        rate.valid?

        # assert
        expect(rate.errors.full_messages).to include 'Preço de Temporada não pode ter conflito de datas com outros Preços de Temporadas'
      end

      it 'when the existing period rate is entirely inside of the new rate' do
        # arrange
        user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :host)

        inn = user.create_inn!(brand_name: 'Pousada Teste', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                           street_name: 'Av. da Pousada', number: '10', 
                           neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                           state: 'SP', zip_code: '05616-090'}, status: :active)

        room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                                 max_capacity: 2, rent_price: 50, 
                                 status: :active)

        room.seasonal_rates.create!(start_date: 10.days.from_now,
                                          end_date: 11.days.from_now,
                                          price: '60.99')

        rate = room.seasonal_rates.build(start_date: 9.day.from_now,
                                         end_date: 12.days.from_now)

        # act
        rate.valid?

        # assert
        expect(rate.errors.full_messages).to include 'Preço de Temporada não pode ter conflito de datas com outros Preços de Temporadas'
      end
    end
  end
end
