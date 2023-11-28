require 'rails_helper'

describe 'Host registers a consumable in a reservation' do
  it 'only when authenticated' do
    # arrange
    any_reservation_id = 99999999999

    # act
    visit new_reservation_consumable_path(any_reservation_id)

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'fails if the reservation does not exist' do
    host = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: 'host')

    inn = host.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'}, status: 'active')
    
    invalid_reservation_id = 1

    # act
    login_as host
    visit new_reservation_consumable_path(invalid_reservation_id)

    # assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Essa página não existe'
  end

  it 'only when authenticated as the owner of the inn' do
    # arrange
    host = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: 'host')
    guest = User.create!(email: 'billy@gmail.com', password: 'password',
                          role: 'regular')

    inn = host.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'}, status: 'active')

    room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)

    reservation = room_a.reservations.build(start_date: 1.day.ago,
                                            end_date: 20.days.from_now,
                                            number_guests: '2',
                                            status: 'active', 
                                            code: 'ABC00001', user: guest)
    reservation.save(validate: false)

    # act
    login_as guest
    visit new_reservation_consumable_path(reservation)

    # assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui autorização para essa ação'
  end
  
  it 'from the homepage' do
    # arrange
    host = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: 'host')
    guest = User.create!(email: 'billy@gmail.com', password: 'password',
                          role: 'regular')

    inn = host.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'}, status: 'active')

    room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)

    reservation = room_a.reservations.build(start_date: 1.day.ago,
                                            end_date: 20.days.from_now,
                                            number_guests: '2',
                                            status: 'active', 
                                            code: 'ABC00001', user: guest)
    reservation.save(validate: false)

    # act
    login_as host
    visit root_path
    click_on 'Reservas'
    click_on 'ABC00001'
    click_on 'Registrar Consumo'

    # assert
    expect(current_path).to eq new_reservation_consumable_path(reservation)
    expect(page).to have_content 'Registrar consumo - Reserva ABC00001'
    expect(page).to have_content 'Quarto El Dormitorio'
    expect(page).to have_field 'Descrição', type: 'text'
    expect(page).to have_field 'Preço', type: 'number'
    expect(page).to have_button 'Registrar Consumo'
  end

  context 'if the reservation is not active' do
    it 'the button to create a new consumable does not appear' do
      # arrange
      host = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: 'host')
      guest = User.create!(email: 'billy@gmail.com', password: 'password',
                            role: 'regular')

      inn = host.create_inn!(brand_name: 'Albergue do Billy', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'}, status: 'active')

      room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                                max_capacity: 5, rent_price: 50, status: :active)

      reservation = room_a.reservations.build(start_date: 5.days.from_now,
                                              end_date: 20.days.from_now,
                                              number_guests: '2',
                                              status: 'confirmed', 
                                              code: 'ABC00001', user: guest)
      reservation.save(validate: false)

      # act
      login_as host
      visit reservation_path(reservation)

      # assert
      expect(page).not_to have_link 'Registrar Consumo', href: new_reservation_consumable_path(reservation) 
    end
  
    it 'the url can not be accessed' do
      # arrange
      host = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: 'host')
      guest = User.create!(email: 'billy@gmail.com', password: 'password',
                            role: 'regular')

      inn = host.create_inn!(brand_name: 'Albergue do Billy', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'}, status: 'active')

      room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                                max_capacity: 5, rent_price: 50, status: :active)

      reservation = room_a.reservations.create!(start_date: 5.days.from_now,
                                              end_date: 20.days.from_now,
                                              number_guests: '2',
                                              status: 'confirmed', user: guest)

      # act
      login_as host
      visit new_reservation_consumable_path(reservation)

      # assert
      expect(current_path).to eq reservation_path(reservation)
      expect(page).to have_content 'Não é possível registrar consumo em uma reserva que não está ativa'
    end
  end

  it 'sucessfully' do 
    # arrange
    host = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: 'host')
    guest = User.create!(email: 'billy@gmail.com', password: 'password',
                          role: 'regular')

    inn = host.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'}, status: 'active')

    room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)

    reservation = room_a.reservations.build(start_date: 5.days.from_now,
                                            end_date: 20.days.from_now,
                                            number_guests: '2',
                                            status: 'active', 
                                            code: 'ABC00001', user: guest)
    reservation.save(validate: false)

    # act
    login_as host
    visit new_reservation_consumable_path(reservation)

    travel_to 0.days.from_now.midday do
      fill_in 'Descrição', with: 'Pizza de Calabresa'
      fill_in 'Preço', with: '49.99'
      click_on 'Registrar Consumo'
    end

    # assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'O consumo foi registrado com sucesso'
    expect(page).to have_content 'Consumíveis'
    expect(page).to have_content 'Pizza de Calabresa - R$ 49,99'
    expect(page).to have_content "Registrado em: #{I18n.l(Time.now.to_date)} - 12:00"
  end

  it 'but fails if fails to provide a description or the price' do
    # arrange
    host = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: 'host')
    guest = User.create!(email: 'billy@gmail.com', password: 'password',
                          role: 'regular')

    inn = host.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'}, status: 'active')

    room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)

    reservation = room_a.reservations.build(start_date: 5.days.from_now,
                                            end_date: 20.days.from_now,
                                            number_guests: '2',
                                            status: 'active', 
                                            code: 'ABC00001', user: guest)
    reservation.save(validate: false)

    # act
    login_as host
    visit new_reservation_consumable_path(reservation)

    fill_in 'Descrição', with: ''
    fill_in 'Preço', with: ''
    click_on 'Registrar Consumo'

    # assert
    expect(current_path).not_to eq reservation_path(reservation)
    expect(page).to have_content 'O consumo não pôde ser registrado'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Preço não pode ficar em branco'
  end
end