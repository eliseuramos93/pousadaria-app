require 'rails_helper'

describe 'User starts to reserve a room' do
  it 'successfully' do
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
                             max_capacity: 4, rent_price: 50, status: :active)

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 20.days.from_now,
                                       price: '100')

    # act
    visit root_path
    click_on "Pousadinha do Teste"
    click_on 'Quarto'
    click_on 'Reservar'

    fill_in 'Data de check-in', with: 7.days.from_now
    fill_in 'Data de checkout', with: 13.days.from_now
    fill_in 'Número de hóspedes', with: '3'
    click_on 'Continuar com Reserva'

    # assert
    expect(page).to have_content 'Dados da sua Pré-Reserva'
    start_date = I18n.localize 7.days.from_now.to_date
    end_date = I18n.localize 13.days.from_now.to_date
    expect(page).to have_content "Check-in: #{start_date}"
    expect(page).to have_content "18:00"
    expect(page).to have_content "Checkout: #{end_date}"
    expect(page).to have_content "11:00"
    expect(page).to have_content 'Número de hóspedes: 3'
    expect(page).to have_content "Valor total: R$ 500,00" 
  end

  it 'but fails due to the room not being available in the period' do
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
                             max_capacity: 4, rent_price: 50, status: :active)

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 20.days.from_now,
                                       price: '100')
    reservation = room.reservations.create!(start_date: 5.days.from_now,
                                            end_date: 10.days.from_now,
                                            number_guests: 3,
                                            status: 'confirmed')

    # act
    visit root_path
    click_on "Pousadinha do Teste"
    click_on 'Quarto'
    click_on 'Reservar'

    fill_in 'Data de check-in', with: 7.days.from_now
    fill_in 'Data de checkout', with: 13.days.from_now
    fill_in 'Número de hóspedes', with: '3'
    click_on 'Continuar com Reserva'

    # assert
    expect(page).to have_content 'Não foi possível seguir com sua reserva'
    expect(page).to have_content 'O quarto já está reservado neste período'
    expect(page).to have_field 'Data de check-in'
    expect(page).to have_field 'Data de checkout'
    expect(page).to have_field 'Número de hóspedes'
  end


  it 'but fails due to surpassing the room maximum capacity' do
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
                             max_capacity: 4, rent_price: 50, status: :active)

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 20.days.from_now,
                                       price: '100')

    # act
    visit root_path
    click_on "Pousadinha do Teste"
    click_on 'Quarto'
    click_on 'Reservar'

    fill_in 'Data de check-in', with: 7.days.from_now
    fill_in 'Data de checkout', with: 13.days.from_now
    fill_in 'Número de hóspedes', with: '5'
    click_on 'Continuar com Reserva'

    # assert
    expect(page).to have_content 'Não foi possível seguir com sua reserva'
    expect(page).to have_content 'Número de hóspedes não pode ser maior que a capacidade do quarto'
    expect(page).to have_field 'Data de check-in'
    expect(page).to have_field 'Data de checkout'
    expect(page).to have_field 'Número de hóspedes'
  end

  it 'but fails if leaves blank fields' do
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
                             max_capacity: 4, rent_price: 50, status: :active)

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 20.days.from_now,
                                       price: '100')

    # act
    visit root_path
    click_on "Pousadinha do Teste"
    click_on 'Quarto'
    click_on 'Reservar'

    fill_in 'Data de check-in', with: ''
    fill_in 'Data de checkout', with: ''
    fill_in 'Número de hóspedes', with: ''
    click_on 'Continuar com Reserva'

    # assert
    expect(page).to have_content 'Não foi possível seguir com sua reserva'
    expect(page).to have_content 'Data de check-in não pode ficar em branco'
    expect(page).to have_content 'Data de checkout não pode ficar em branco'
    expect(page).to have_content 'Número de hóspedes não pode ficar em branco'
  end

  it 'but fails if tries to make a reservation with invalid dates' do
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
                             max_capacity: 4, rent_price: 50, status: :active)

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 20.days.from_now,
                                       price: '100')

    # act
    visit root_path
    click_on "Pousadinha do Teste"
    click_on 'Quarto'
    click_on 'Reservar'

    fill_in 'Data de check-in', with: 2.days.ago
    fill_in 'Data de checkout', with: 1.day.ago
    fill_in 'Número de hóspedes', with: '3'
    click_on 'Continuar com Reserva'

    # assert
    expect(page).to have_content 'Não foi possível seguir com sua reserva'
    expect(page).to have_content 'Data de check-in não pode ser no passado'
    expect(page).to have_content 'Data de checkout não pode ser no passado'
  end

  it 'but fails due to start date being ahead of end date' do
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
                             max_capacity: 4, rent_price: 50, status: :active)

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 20.days.from_now,
                                       price: '100')

    # act
    visit root_path
    click_on "Pousadinha do Teste"
    click_on 'Quarto'
    click_on 'Reservar'

    fill_in 'Data de check-in', with: 3.days.from_now
    fill_in 'Data de checkout', with: 2.days.from_now
    fill_in 'Número de hóspedes', with: '3'
    click_on 'Continuar com Reserva'

    # assert
    expect(page).to have_content 'Não foi possível seguir com sua reserva'
    expect(page).to have_content 'Data de check-in não pode ser depois do checkout'
  end
end