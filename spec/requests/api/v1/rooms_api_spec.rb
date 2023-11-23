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
      expect(response.body).to include 'Não existe pousada com esse id.'
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
end