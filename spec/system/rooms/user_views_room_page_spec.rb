require 'rails_helper'

describe 'User visits a room details page' do
  it 'even if not authenticated' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)

    # act
    visit inn_room_path(inn.id, room.id)

    # assert
    expect(current_path).to eq inn_room_path(inn.id, room.id)
  end

  it 'only when the room is available' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :inactive)

    # act
    visit inn_room_path(inn.id, room.id)

    # assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Este quarto não está disponível no momento.'
  end

  it "and sees the room's information" do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)

    # act
    visit inn_room_path(inn.id, room.id)

    # assert
    expect(page).to have_content 'Quarto Bedroom'
    expect(page).not_to have_content 'Quarto disponível para reservas'
    expect(page).to have_content 'Área: 10 m²'
    expect(page).to have_content 'Capacidade: 2 pessoas'
    expect(page).to have_content 'Valor da Diária: R$ 50,00'
    expect(page).to have_content 'Não possui banheiro próprio'
    expect(page).to have_content 'Não possui ar condicionado'
    expect(page).to have_content 'Não possui varanda'
    expect(page).to have_content 'Não possui TV'
    expect(page).to have_content 'Não possui guarda-roupas'
    expect(page).to have_content 'Não possui cofre'
    expect(page).to have_content 'Quarto não foi projetado com acessibilidade'
  end

  it 'and returns to homepage' do
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)

    # act
    visit inn_room_path(inn.id, room.id)
    click_on 'Pousadaria'

    # assert
    expect(current_path).to eq root_path
  end

  it 'and accesses the login page' do
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)

    # act
    visit inn_room_path(inn.id, room.id)
    click_on 'Entrar'

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'and returns to the inn details page' do
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)

    # act
    visit inn_room_path(inn.id, room.id)
    click_on 'Voltar para Pousada Teste'

    # assert
    expect(current_path).to eq inn_path(inn.id)
  end
end