require 'rails_helper'

describe 'Regular user visits reservation list page' do
  it 'only when authenticated' do
    # arrange

    # act
    visit my_reservations_path

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'from a link at the navigation bar' do
    # arrange
    host = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)
    guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                        role: :regular, first_name: 'Reginaldo', 
                        last_name: 'Rossi')
                        
    inn = host.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})

    room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    reservation = room.reservations.create!(start_date: 5.days.from_now,
                                              end_date: 9.days.from_now,
                                              number_guests: '2',
                                              status: 'confirmed',
                                              user: guest)

    # act
    login_as guest
    visit root_path
    within 'nav' do
      click_on 'Minhas Reservas'
    end

    # assert
    expect(page).to have_content 'Minhas Reservas'
    expect(page).to have_link "Reserva ABC00001", href: reservation_path(reservation)
    expect(page).to have_content 'Pousada: Albergue do Billy'
    expect(page).to have_content 'Quarto El Dormitorio'
    start_date = 5.days.from_now.to_date
    end_date = 9.days.from_now.to_date
    expect(page).to have_content "Check-in: #{I18n.l(start_date)} - 18:00"
    expect(page).to have_content "Check-out: #{I18n.l(end_date)} - 11:00"
    expect(page).to have_content 'Valor: R$ 250,00'
    expect(page).to have_content 'Status da reserva: Confirmada'
    expect(page).to have_button 'Cancelar Reserva de El Dormitorio'
  end
end