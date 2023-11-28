require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Host registers a checkout for a reservation' do
  it 'only when authenticated' do
    # arrange
    foobar_id = 1823981

    # act
    visit new_reservation_checkout_path(foobar_id)

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'successfully' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)

    inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})

    room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)

    reservation = room_a.reservations.build(start_date: 2.days.ago,
                                            end_date: 10.days.from_now,
                                            number_guests: '2',
                                            status: 'active',
                                            code: 'ABC00001')
    reservation.save(validate: false)
    reservation.create_checkin!

    # act
    login_as user
    visit root_path
    click_on 'Reservas'
    click_on 'ABC00001'
    click_on 'Registrar Check-out'

    select 'PIX', from: 'Forma de pagamento'
    click_on 'Confirmar Check-out'

    # assert
    expect(page).to have_content 'Check-out registrado com sucesso!'
    expect(page).to have_content 'Status: Concluída'
  end

  it 'and updates the price correctly' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)

    inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})

    room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)
    
    allow(SecureRandom).to receive(:alphanumeric).and_return 'ABC00001'
    reservation = room_a.reservations.create!(start_date: Date.today,
                                            end_date: 10.days.from_now,
                                            number_guests: '2',
                                            status: 'active')
    reservation.create_checkin!


    # act
    login_as user
    visit root_path
    click_on 'Reservas'
    click_on 'ABC00001'
    click_on 'Registrar Check-out'
    
    day = 5.days.from_now.day
    month = 5.days.from_now.month
    year = 5.days.from_now.year

    travel_to Time.zone.local(year, month, day, 11, 1, 0) do 
      select 'PIX', from: 'Forma de pagamento'
      click_on 'Confirmar Check-out'
    end

    visit reservation_path(reservation)

    # assert
    expect(page).to have_content "Check-out: #{I18n.l(5.days.from_now.to_date)}"
    expect(page).to have_content 'Status: Concluída'
    expect(page).to have_content 'Valor: R$ 300,00'
  end

  it 'and updates the price with the registered consumables' do
    # arrange
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)

    inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})

    room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)
    
    allow(SecureRandom).to receive(:alphanumeric).and_return 'ABC00001'
    reservation = room_a.reservations.create!(start_date: Date.today,
                                            end_date: 10.days.from_now,
                                            number_guests: '2',
                                            status: 'active')
    reservation.create_checkin!
    reservation.consumables.create!(description: 'Coca-Cola', price: 14.99)
    reservation.consumables.create!(description: 'Pizza', price: 40.00)

    # act
    login_as user
    visit root_path
    click_on 'Reservas'
    click_on 'ABC00001'
    click_on 'Registrar Check-out'
    
    day = 5.days.from_now.day
    month = 5.days.from_now.month
    year = 5.days.from_now.year

    travel_to Time.zone.local(year, month, day, 11, 1, 0) do 
      select 'PIX', from: 'Forma de pagamento'
      click_on 'Confirmar Check-out'
    end

    visit reservation_path(reservation)

    # assert
    expect(page).to have_content "Check-out: #{I18n.l(5.days.from_now.to_date)}"
    expect(page).to have_content 'Status: Concluída'
    expect(page).to have_content 'Valor: R$ 354,99'
  end
end