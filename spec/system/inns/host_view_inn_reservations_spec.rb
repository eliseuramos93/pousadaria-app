require 'rails_helper'

describe 'Host views the list of reservations of his/her inn' do
  it 'only when authenticated' do
    # arrange

    # act
    visit my_inn_reservations_path

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'and views a list of all with all reservations in different rooms' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)
    guest = User.create!(email: 'guest@gmail.com', password: 'password',
                        role: :regular)

    inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})

    room_a = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)
    room_b = inn.rooms.create!(name: 'The Bedroom', description: 'Great', area: 20,
                              max_capacity: 5, rent_price: 100, status: :active)

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    room_a.reservations.create!(user: guest, 
                                            start_date: 10.day.from_now,
                                            end_date: 20.days.from_now,
                                            number_guests: '2',
                                            status: 'confirmed')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00002')
    room_b.reservations.create!(user: guest, 
                                            start_date: 5.day.from_now,
                                            end_date: 10.days.from_now,
                                            number_guests: '3',
                                            status: 'canceled')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00003')
    room_a.reservations.create!(user: guest, 
                                            start_date: 10.days.ago,
                                            end_date: 2.days.ago,
                                            number_guests: '1',
                                            status: 'finished')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00004')
    room_a.reservations.create!(user: guest, 
                                            start_date: 21.days.from_now,
                                            end_date: 30.days.from_now,
                                            number_guests: '3',
                                            status: 'active')
    # act
    login_as user
    visit root_path
    click_on 'Reservas'

    # assert
    expect(page).to have_content 'Reservas - Albergue do Billy'
    expect(page).to have_content 'Reserva ABC00001'
    expect(page).to have_content 'Quarto El Dormitorio'
    expect(page).to have_content "Check-in: #{I18n.l(10.days.from_now.to_date)} - 18:00"
    expect(page).to have_content "Check-out: #{I18n.l(20.days.from_now.to_date)} - 11:00"
    expect(page).to have_content "Hóspedes: 2"
    expect(page).to have_content "Status: Confirmada"

    expect(page).to have_content 'Reserva ABC00002'
    expect(page).to have_content 'Quarto The Bedroom'
    expect(page).to have_content "Check-in: #{I18n.l(5.days.from_now.to_date)} - 18:00"
    expect(page).to have_content "Check-out: #{I18n.l(10.days.from_now.to_date)} - 11:00"
    expect(page).to have_content "Hóspedes: 2"
    expect(page).to have_content "Status: Cancelada"

    expect(page).to have_content 'Reserva ABC00003'
    expect(page).to have_content 'Quarto El Dormitorio'
    expect(page).to have_content "Check-in: #{I18n.l(10.days.ago.to_date)} - 18:00"
    expect(page).to have_content "Check-out: #{I18n.l(2.days.ago.to_date)} - 11:00"
    expect(page).to have_content "Hóspedes: 2"
    expect(page).to have_content "Status: Concluída"

    within '#active-reservations' do
      expect(page).to have_content 'Reserva ABC00004'
      expect(page).to have_content 'Quarto El Dormitorio'
      expect(page).to have_content "Check-in: #{I18n.l(21.days.from_now.to_date)} - 18:00"
      expect(page).to have_content "Check-out: #{I18n.l(30.days.from_now.to_date)} - 11:00"
      expect(page).to have_content "Hóspedes: 3"
      expect(page).to have_content "Status: Ativa"
    end
  end
end