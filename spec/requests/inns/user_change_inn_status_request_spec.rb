require 'rails_helper'

describe 'User requests to change a specific inn status' do
  it 'and must be authenticated' do
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

    # act
    post inactive_inn_path(inn.id)

    # assert
    expect(response).to redirect_to new_user_session_path
  end

  it 'but fails due to being a regular user' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    another_user = User.create!(email: 'billy@gmail.com', password: 'password',
                                role: :regular)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})

    # act
    login_as another_user
    post active_inn_path(inn.id)

    # assert
    expect(response).to redirect_to root_path
  end

  it "and must be the inn's owner to change the status" do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    another_user = User.create!(email: 'billy@gmail.com', password: 'password',
                                role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    another_user.create_inn!(brand_name: 'Pousada Teste 2', 
                        registration_number: '582779834230198', 
                        phone_number: '(11) 564651321', checkin_time: '18:00',
                        checkout_time: '11:00', address_attributes: {
                          street_name: 'Av. da Pousada', number: '10', 
                          neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                          state: 'SP', zip_code: '05616-090'})
    # act
    login_as another_user
    post active_inn_path(inn.id)

    # assert
    expect(response).to redirect_to root_path
  end
end