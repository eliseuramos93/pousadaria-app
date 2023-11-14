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

  it 'but is redirected if not on valid date' do
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
    start_date = 10.days.from_now.to_date
    expect(page).to have_content "Check-in só pode ser feito a partir de #{I18n.l(start_date)}"
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

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    room_a.reservations.create!(start_date: 0.days.from_now,
                                end_date: 20.days.from_now,
                                number_guests: '2',
                                status: 'confirmed')

    # act
    login_as user
    visit root_path
    click_on 'Reservas'
    click_on 'ABC00001'
    click_on 'Registrar Check-in'
    click_on 'Confirmar Check-in'

    # assert
    expect(current_path).to eq my_inn_reservations_path
    expect(page).to have_content "Check-in registrado com sucesso!"
    within '#active-reservations' do
      expect(page).to have_content 'Reserva ABC00001'
      expect(page).to have_content 'Quarto El Dormitorio'
      expect(page).to have_content "Check-in: #{I18n.l(0.days.from_now.to_date)} - 18:00"
      expect(page).to have_content "Check-out: #{I18n.l(20.days.from_now.to_date)} - 11:00"
      expect(page).to have_content "Hóspedes: 2"
      expect(page).to have_content "Status: Ativa"
    end
  end
end