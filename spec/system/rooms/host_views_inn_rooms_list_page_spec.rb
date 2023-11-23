require 'rails_helper'

describe "Host visits an inn's room list page" do 
  it 'only when authenticated' do
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
    visit inn_rooms_path(inn.id)

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'only for a room that belongs to him/her' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    another_user = User.create!(email: 'another@gmail.com', password: 'password',
                                role: 'host')

    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'}, status: 'active')
    another_user.create_inn!(brand_name: 'Outra Pousada Teste', 
                              registration_number: '58277983000198', 
                              phone_number: '(11) 976834383', 
                              checkin_time: '18:00', checkout_time: '11:00', 
                              address_attributes: {
                                street_name: 'Av. da Pousada', number: '10', 
                                neighborhood: 'Bairro da Pousada', 
                                city: 'São Paulo', state: 'SP', 
                                zip_code: '05616-090'})

    # act
    login_as another_user
    visit inn_rooms_path(inn.id)

    # assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui autorização para essa ação.'
  end

  it 'and sees the full list of rooms' do
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
    login_as user
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Ver Meus Quartos'

    # assert
    expect(page).to have_content "Quartos de #{inn.brand_name}"
    expect(page).to have_link room_a.name, href: room_path(room_a)
    expect(page).to have_link room_b.name, href: room_path(room_b)
    expect(page).to have_link room_c.name, href: room_path(room_c)
    expect(page).to have_content('Disponível').twice
    expect(page).to have_content('Indisponível').once
  end
end