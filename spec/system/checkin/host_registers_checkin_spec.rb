require 'rails_helper'

describe 'Host registers a new checkin' do
  it 'only when authenticated' do
    # arrange
    foobar_reservation_id = 1
    # act
    visit new_reservation_checkin_path(foobar_reservation_id)

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

    reservation = room_a.reservations.build(start_date: 1.day.ago,
                                            end_date: 20.days.from_now,
                                            number_guests: '2',
                                            status: 'confirmed', 
                                            code: 'ABC00001')
    reservation.save(validate: false)

    # act
    login_as user
    visit root_path
    click_on 'Reservas'
    click_on 'ABC00001'
    click_on 'Registrar Check-in'

    fill_in 'Nome - Hóspede 1', with: 'Cassio Ramos'
    fill_in 'Documento - Hóspede 1', with: '61806739003'
    fill_in 'Nome - Hóspede 2', with: 'Yuri Alberto'
    fill_in 'Documento - Hóspede 2', with: '33013560010'
    click_on 'Confirmar Check-in'

    # assert
    expect(current_path).to eq my_inn_reservations_path
    expect(page).to have_content "Check-in registrado com sucesso!"
    within '#active-reservations' do
      expect(page).to have_content 'Reserva ABC00001'
      expect(page).to have_content 'Quarto El Dormitorio'
      expect(page).to have_content "Check-in: #{I18n.l(1.day.ago.to_date)} - 18:00"
      expect(page).to have_content "Check-out: #{I18n.l(20.days.from_now.to_date)} - 11:00"
      expect(page).to have_content "Hóspedes: 2"
      expect(page).to have_content "Status: Ativa"
    end

    expect(reservation.checkin.guests.first.full_name).to eq 'Cassio Ramos'
    expect(reservation.checkin.guests.first.document).to eq '61806739003'
    expect(reservation.checkin.guests.second.full_name).to eq 'Yuri Alberto'
    expect(reservation.checkin.guests.second.document).to eq '33013560010'
  end

  it 'but fails if do not provide guests information' do
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

    reservation = room_a.reservations.build(start_date: 1.day.ago,
                                            end_date: 20.days.from_now,
                                            number_guests: '2',
                                            status: 'confirmed', 
                                            code: 'ABC00001')
    reservation.save(validate: false)

    # act
    login_as user
    visit root_path
    click_on 'Reservas'
    click_on 'ABC00001'
    click_on 'Registrar Check-in'

    fill_in 'Nome - Hóspede 1', with: ''
    fill_in 'Documento - Hóspede 1', with: ''
    fill_in 'Nome - Hóspede 2', with: 'Yuri Alberto'
    fill_in 'Documento - Hóspede 2', with: '33013560010'
    click_on 'Confirmar Check-in'

    # assert
    expect(current_path).not_to eq my_inn_reservations_path
    expect(page).to have_content 'Não foi possível confirmar o checkin'
    expect(page).to have_content 'Nome do hóspede não pode ficar em branco'
    expect(page).to have_content 'Documento do hóspede não pode ficar em branco'
  end
end

describe 'Host attempts an invalid checkin' do
  it 'but is redirected if before the reservation start date' do
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

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    room_a.reservations.create!(start_date: 10.days.from_now,
                                end_date: 20.days.from_now,
                                number_guests: '2',
                                status: 'confirmed')

    # act
    login_as user
    visit root_path
    click_on 'Reservas'
    click_on 'ABC00001'
    click_on 'Registrar Check-in'

    # assert
    expect(current_path).to eq my_inn_reservations_path
    expect(page).to have_content "Não é possível realizar check-in nessa reserva"
  end

  it 'but is redirected if the reservation is already active' do
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

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    reservation = room_a.reservations.create!(start_date: 0.days.from_now,
                                end_date: 20.days.from_now,
                                number_guests: '2',
                                status: 'active')

    # act
    login_as user
    visit new_reservation_checkin_path(reservation)

    # assert
    expect(current_path).to eq my_inn_reservations_path
    expect(page).to have_content "Não é possível realizar check-in nessa reserva"
  end

  it 'but is redirected if the reservation is canceled' do
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

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    reservation = room_a.reservations.create!(start_date: 10.days.from_now,
                                end_date: 20.days.from_now,
                                number_guests: '2',
                                status: 'canceled')

    # act
    login_as user
    visit new_reservation_checkin_path(reservation)

    # assert
    expect(current_path).to eq my_inn_reservations_path
    expect(page).to have_content "Não é possível realizar check-in nessa reserva"
  end

  it 'but is redirected if the reservation is finished' do
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

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    reservation = room_a.reservations.create!(start_date: 5.days.ago,
                                end_date: 1.day.ago,
                                number_guests: '2',
                                status: 'finished')

    # act
    login_as user
    visit new_reservation_checkin_path(reservation)

    # assert
    expect(current_path).to eq my_inn_reservations_path
    expect(page).to have_content "Não é possível realizar check-in nessa reserva"
  end
end