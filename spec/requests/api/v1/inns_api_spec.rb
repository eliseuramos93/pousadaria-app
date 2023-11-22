require 'rails_helper'

# Listagem de pousadas: uma listagem completa das pousadas cadastradas e ativas 
# na plataforma. Deve haver uma opção de informar um texto e usar como filtro de 
# busca pelo nome da pousada.

describe 'Inn API' do
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
      expect(response).to have_http_status(200)
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
  end
end