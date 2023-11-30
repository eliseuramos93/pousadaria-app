require 'rails_helper'

describe 'Rooms API' do
  context 'GET /api/v1/inns/:inn_id/rooms/' do
    it 'list all active rooms of an specific inn' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
      role: :host)

      inn = user.create_inn!(brand_name: 'Pousada Teste', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'}, status: 'active')

      room_a = inn.rooms.create!(name: 'Amaral', description: 'Futebol', area: 10,
                                 max_capacity: 2, rent_price: 50, status: :inactive)
      room_b = inn.rooms.create!(name: 'Beckham', description: 'Football', area: 15,
                                 max_capacity: 3, rent_price: 100, status: :active)
      room_c = inn.rooms.create!(name: 'Careca', description: 'Boleiro', area: 20,
                                 max_capacity: 4, rent_price: 25, status: :active)

      # act
      get "/api/v1/inns/#{inn.id}/rooms/"
      
      # assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2

      expect(json_response.first['name'])
      expect(json_response.first['description'])
      expect(json_response.first['area'])
      expect(json_response.first['max_capacity'])
      expect(json_response.first['rent_price'])
      
      expect(json_response.second['name'])
      expect(json_response.second['description'])
      expect(json_response.second['area'])
      expect(json_response.second['max_capacity'])
      expect(json_response.second['rent_price'])

      expect(json_response.first.keys).not_to include 'created_at'
      expect(json_response.first.keys).not_to include 'updated_at'
    end

    it 'returns an empty hash due to the inn not having any rooms' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
      role: :host)

      inn = user.create_inn!(brand_name: 'Pousada Teste', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'}, status: 'active')

      # act
      get "/api/v1/inns/#{inn.id}/rooms/"
      
      # assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response).to eq []
    end

    it 'fails due to the room not being found' do
      # arrange
      # act
      get '/api/v1/inns/99999999999/rooms'

      # assert
      expect(response).to have_http_status(404)
      expect(response.body).to include 'O id informado não foi encontrado.'
    end

    it 'raises an internal server error' do
      # arrange
      allow(Inn).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      # act
      get '/api/v1/inns/1/rooms/'

      # assert
      expect(response).to have_http_status(500)
      expect(response.body).to include 'Ops, tivemos um erro no servidor.'
    end
  end

  context 'POST /api/v1/rooms/:room_id/check_availability/' do
    it 'returns the price of the room if it is available' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)

      inn = user.create_inn!(brand_name: 'Pousadinha do Teste', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'}, 
                            status: 'active')

      room = inn.rooms.create!(name: 'Quarto', description: 'Nice', area: 10,
                              max_capacity: 4, rent_price: 50, status: 'active')

      rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                          end_date: 20.days.from_now,
                                          price: '100')

      reservation_params = { start_date: 9.days.from_now,
                            end_date: 11.days.from_now,
                            number_guests: 3 }

      # act
      post "/api/v1/rooms/#{room.id}/check_availability", params: reservation_params

      # assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['price']).to eq 150.0
      expect(json_response.keys).not_to include 'user_id'
      expect(json_response.keys).not_to include 'room_id'
      expect(json_response.keys).not_to include 'status'
      expect(json_response.keys).not_to include 'created_at'
      expect(json_response.keys).not_to include 'updated_at'
      
    end

    it 'returns an error hash if the room is not available' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)

      inn = user.create_inn!(brand_name: 'Pousadinha do Teste', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'}, 
                            status: 'active')

      room = inn.rooms.create!(name: 'Quarto', description: 'Nice', area: 10,
                              max_capacity: 4, rent_price: 50, status: 'active')

      rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                          end_date: 20.days.from_now,
                                          price: '100')
      room.reservations.create!(start_date: 5.days.from_now, 
                                end_date: 20.days.from_now,
                                number_guests: 3)

      reservation_params = { start_date: 9.days.from_now,
                            end_date: 11.days.from_now,
                            number_guests: 5 }

      # act
      post "/api/v1/rooms/#{room.id}/check_availability", params: reservation_params

      # assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['errors']).to include 'Número de hóspedes não pode ser maior que a capacidade do quarto'
      expect(json_response['errors']).to include 'O quarto já está reservado neste período'
      expect(json_response.keys).not_to include 'price'
    end

    it 'fails if the room does not exist' do
      # arrange

      # act
      post '/api/v1/rooms/99999999999/check_availability'

      # assert
      expect(response).to have_http_status(404)
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'O id informado não foi encontrado'
    end

    it 'raises an internal server error' do
      # arrange
      allow(Room).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      # act
      post '/api/v1/rooms/1/check_availability/'

      # assert
      expect(response).to have_http_status(500)
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Ops, tivemos um erro no servidor.'
    end
  end
end