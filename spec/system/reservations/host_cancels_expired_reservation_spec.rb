require 'rails_helper'

describe 'Host cancels a reservation for a room' do
  it 'only when authenticated' do
    # arrange
    foobar_reservation_id = 1
    # act
    visit reservation_path(foobar_reservation_id)

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

    reservation = room_a.reservations.build(start_date: 4.days.ago,
                                end_date: 20.days.from_now,
                                number_guests: '2',
                                status: 'confirmed', code: 'ABC00001')
    reservation.save(validate: false)

    # act
    login_as user
    visit root_path
    click_on 'Reservas'
    click_on 'Reserva ABC00001'
    click_on 'Cancelar Reserva Expirada'

    # assert
    expect(page).to have_content 'A reserva foi cancelada com sucesso!'
    expect(page).to have_content 'Reserva ABC00001'
    expect(page).to have_content 'Quarto El Dormitorio'
    expect(page).to have_content "Check-in: #{I18n.l(4.days.ago.to_date)} - 18:00"
    expect(page).to have_content "Check-out: #{I18n.l(20.days.from_now.to_date)} - 11:00"
    expect(page).to have_content "Hóspedes: 2"
    expect(page).to have_content "Status: Cancelada"
  end

  it 'only after two days from start date, and beyond' do
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
                                status: 'confirmed', code: 'ABC00001')
    reservation.save(validate: false)

    # act
    login_as user
    visit root_path
    click_on 'Reservas'
    click_on 'Reserva ABC00001'
    click_on 'Cancelar Reserva Expirada'

    # assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Não é possível cancelar a reserva com menos de 3 dias de atraso.'
  end
end