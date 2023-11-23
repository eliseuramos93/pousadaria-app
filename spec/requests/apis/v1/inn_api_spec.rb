require 'rails_helper'

describe 'Inns API' do
  context 'GET /api/v1/inns/' do
    it 'list all active inns' do
      # arrange
      user_a = User.create!(email: 'andre@gmail.com', password: 'password', 
      role: 'host')
      user_b = User.create!(email: 'bento@gmail.com', password: 'password', 
          role: 'host')
      user_c = User.create!(email: 'celso@gmail.com', password: 'password', 
          role: 'host')

      inn_a = user_a.create_inn!(brand_name: "Pousada do André", 
                                  registration_number: '12345612318', 
                                  phone_number: '(11) 109238019', 
                                  checkin_time: '19:00', checkout_time: '12:00',
                                  address_attributes: {
                                    street_name: 'Av. Angelica', number: '1',
                                    neighborhood: 'Bairro A', city: 'São Paulo',
                                    state: 'SP', zip_code: '01000-000' },
                                  status: 'active')
      inn_b = user_b.create_inn!(brand_name: "Pousada do Bento", 
                                  registration_number: '18273981731', 
                                  phone_number: '(11) 189237189', 
                                  checkin_time: '20:00', checkout_time: '11:00',
                                  address_attributes: {
                                      street_name: 'R. Birigui', number: '12',
                                      neighborhood: 'Bairro B', city: 'Barueri',
                                      state: 'SP', zip_code: '02000-000' },
                                  status: 'inactive')
      inn_c = user_c.create_inn!(brand_name: "Canto do Celso", 
                                  registration_number: '18273981731', 
                                  phone_number: '(11) 189237189', 
                                  checkin_time: '20:00', checkout_time: '11:00',
                                  address_attributes: {
                                    street_name: 'R. Cubatão', number: '33',
                                    neighborhood: 'São Paulo', city: 'Birigui',
                                    state: 'SP', zip_code: '03000-000' },
                                  status: 'active')

      # act
      get "/api/v1/inns/"

      # assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response.first['brand_name']).to eq 'Pousada do André'
      expect(json_response.second['brand_name']).to eq 'Canto do Celso'
      expect(json_response.first['registration_number']).to eq '12345612318'
      expect(json_response.second['registration_number']).to eq '18273981731'
      expect(json_response.first['phone_number']).to eq '(11) 109238019'
      expect(json_response.second['phone_number']).to eq '(11) 189237189'
      expect(json_response.first['address']['city']).to eq 'São Paulo'
      expect(json_response.second['address']['city']).to eq 'Birigui'
      expect(json_response.first.keys).not_to include 'status'
      expect(json_response.first.keys).not_to include 'user_id'
      expect(json_response.first.keys).not_to include 'created_at'
      expect(json_response.first.keys).not_to include 'updated_at'
      expect(json_response.first['address'].keys).not_to include 'id'
      expect(json_response.first['address'].keys).not_to include 'inn_id'
      expect(json_response.first['address'].keys).not_to include 'created_at'
      expect(json_response.first['address'].keys).not_to include 'updated_at'
    end

    it 'list all active inns filtered by name if parameter is given' do
      # arrange
      user_a = User.create!(email: 'andre@gmail.com', password: 'password', 
      role: 'host')
      user_b = User.create!(email: 'bento@gmail.com', password: 'password', 
          role: 'host')
      user_c = User.create!(email: 'celso@gmail.com', password: 'password', 
          role: 'host')

      inn_a = user_a.create_inn!(brand_name: "Pousada do André", 
                                  registration_number: '12345612318', 
                                  phone_number: '(11) 109238019', 
                                  checkin_time: '19:00', checkout_time: '12:00',
                                  address_attributes: {
                                    street_name: 'Av. Angelica', number: '1',
                                    neighborhood: 'Bairro A', city: 'São Paulo',
                                    state: 'SP', zip_code: '01000-000' },
                                  status: 'active')
      inn_b = user_b.create_inn!(brand_name: "Pousada do Bento", 
                                  registration_number: '18273981731', 
                                  phone_number: '(11) 189237189', 
                                  checkin_time: '20:00', checkout_time: '11:00',
                                  address_attributes: {
                                      street_name: 'R. Birigui', number: '12',
                                      neighborhood: 'Bairro B', city: 'Barueri',
                                      state: 'SP', zip_code: '02000-000' },
                                  status: 'inactive')
      inn_c = user_c.create_inn!(brand_name: "Canto do Celso", 
                                  registration_number: '18273981731', 
                                  phone_number: '(11) 189237189', 
                                  checkin_time: '20:00', checkout_time: '11:00',
                                  address_attributes: {
                                    street_name: 'R. Cubatão', number: '33',
                                    neighborhood: 'São Paulo', city: 'Birigui',
                                    state: 'SP', zip_code: '03000-000' },
                                  status: 'active')
      
      search_params = {name: 'Pousada'}

      # act
      get "/api/v1/inns/", params: search_params

      # assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      expect(json_response.first['brand_name']).to eq 'Pousada do André'
      expect(json_response.first['registration_number']).to eq '12345612318'
      expect(json_response.first['phone_number']).to eq '(11) 109238019'
      expect(json_response.first['address']['city']).to eq 'São Paulo'
      expect(json_response).not_to include 'Canto do Celso'
    end

    it 'returns empty if there is no inns found' do
      # arrange

      # act
      get '/api/v1/inns/'

      # assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'and raise internal error' do
      # arrange
      allow(Inn).to receive(:active).and_raise(ActiveRecord::QueryCanceled)

      # act
      get '/api/v1/inns/'

      # assert
      expect(response).to have_http_status(500)
      expect(response.body).to include 'Ops, tivemos um erro no servidor.'
    end
  end

  context 'GET /api/v1/inns/:id' do
    it 'returns the data of the inn', type: :request do
      # arrange
      host = User.create!(email: 'test@gmail.com', password: 'password', 
      role: :host)
      guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
        role: :regular, first_name: 'Reginaldo', 
        last_name: 'Rossi')
        
      inn = host.create_inn!(brand_name: 'Albergue do Billy', 
          registration_number: '58277983000198', 
          phone_number: '(11) 976834383', checkin_time: '18:00',
          checkout_time: '11:00', address_attributes: {
            street_name: 'Av. da Pousada', number: '10', 
            neighborhood: 'Bairro da Pousada', city: 'Piracicaba',
            state: 'SP', zip_code: '05616-090'}, status: 'active')

      room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
              max_capacity: 5, rent_price: 50, status: :active)

      reservation_a = room.reservations.create!(start_date: 1.days.from_now,
                              end_date: 2.days.from_now,
                              number_guests: '2',
                              status: 'finished',
                              user: guest)

      reservation_b = room.reservations.create!(start_date: 3.days.from_now,
                              end_date: 4.days.from_now,
                              number_guests: '2',
                              status: 'finished',
                              user: guest)

      reservation_c = room.reservations.create!(start_date: 5.days.from_now,
                              end_date: 6.days.from_now,
                              number_guests: '2',
                              status: 'finished',
                              user: guest)

      reservation_d = room.reservations.create!(start_date: 7.days.from_now,
                              end_date: 9.days.from_now,
                              number_guests: '2',
                              status: 'finished',
                              user: guest)

      review_a = reservation_a.create_review!(rating: 5, comment: 'Muito bom!')
      review_b = reservation_b.create_review!(rating: 4, comment: 'Muito bom!')
      review_c = reservation_c.create_review!(rating: 3, comment: 'Muito bom!')
      review_d = reservation_d.create_review!(rating: 2, comment: 'Muito bom!')
      

      # act
      get "/api/v1/inns/#{inn.id}"

      # assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash

      expect(json_response['brand_name']).to eq 'Albergue do Billy'
      expect(json_response['phone_number']).to eq '(11) 976834383'
      expect(json_response['checkin_time']).to include '18:00'
      expect(json_response['checkout_time']).to include '11:00'
      expect(json_response['address']['street_name']).to eq 'Av. da Pousada'
      expect(json_response['address']['number']).to eq '10'
      expect(json_response['address']['neighborhood']).to eq 'Bairro da Pousada'
      expect(json_response['address']['city']).to eq 'Piracicaba'
      expect(json_response['address']['state']).to eq 'SP'
      expect(json_response['address']['zip_code']).to eq '05616-090'
      expect(json_response['status']).to eq 'active'
      expect(json_response['average_rating']).to eq 3.50

      expect(json_response.keys).not_to include 'created_at'
      expect(json_response.keys).not_to include 'updated_at'
      expect(json_response.keys).not_to include 'user_id'
      expect(json_response.keys).not_to include 'registration_number'
    end

    it 'returns a blank average ratings if inn does not have reviews' do
      # arrange
      host = User.create!(email: 'test@gmail.com', password: 'password', 
      role: :host)
      guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
        role: :regular, first_name: 'Reginaldo', 
        last_name: 'Rossi')
        
      inn = host.create_inn!(brand_name: 'Albergue do Billy', 
          registration_number: '58277983000198', 
          phone_number: '(11) 976834383', checkin_time: '18:00',
          checkout_time: '11:00', address_attributes: {
            street_name: 'Av. da Pousada', number: '10', 
            neighborhood: 'Bairro da Pousada', city: 'Piracicaba',
            state: 'SP', zip_code: '05616-090'}, status: 'active')

      # act
      get "/api/v1/inns/#{inn.id}"

      # assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['average_rating']).to eq ''

    end
    
    it 'returns an error due to an invalid inn id' do
      # arrange

      # act
      get '/api/v1/inns/999999999999999'

      # assert
      expect(response).to have_http_status(404)
      expect(response.body).to include 'O id informado não foi encontrado.'
    end

    it 'raises an internal server error' do
      # arrange
      allow(Inn).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      # act
      get '/api/v1/inns/1'

      # assert
      expect(response).to have_http_status(500)
      expect(response.body).to include 'Ops, tivemos um erro no servidor.'
    end
  end
end