require 'rails_helper'

describe 'User visits a reservation details page' do
  it 'only when authenticated' do
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
    reservation = room_a.reservations.create!(start_date: 10.day.from_now,
                                            end_date: 20.days.from_now,
                                            number_guests: '2',
                                            status: 'confirmed')

    # act
    visit reservation_path(reservation)

    # assert
    expect(current_path).to eq new_user_session_path
  end

  context 'logged in as the owner of the inn' do
    it 'and sees the options to make a checkin, checkout and cancel the reservation' do
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
      reservation = room_a.reservations.create!(start_date: 10.day.from_now,
                                              end_date: 20.days.from_now,
                                              number_guests: '2',
                                              status: 'confirmed')

      # act
      login_as user
      visit root_path
      click_on 'Reservas'
      click_on 'Reserva ABC00001'

      # assert
      expect(page).to have_content 'Reserva ABC00001'
      expect(page).to have_content 'Quarto El Dormitorio'
      expect(page).to have_content "Check-in: #{I18n.l(10.days.from_now.to_date)} - 18:00"
      expect(page).to have_content "Check-out: #{I18n.l(20.days.from_now.to_date)} - 11:00"
      expect(page).to have_content "Hóspedes: 2"
      expect(page).to have_content "Status: Confirmada"
      expect(page).to have_content "Valor: R$ 550,00"
      expect(page).to have_link 'Registrar Check-in'
      expect(page).to have_button 'Cancelar Reserva'
      expect(page).to have_link 'Registrar Check-out'
    end
  end

  context 'logged in as the person who made the reservation' do
    it 'and is able to see the hosts reply for their review' do
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
                                                status: 'finished',
                                                user: guest)

      review = reservation.create_review!(rating: 5, comment: 'Muito bom!')

      host_reply = review.create_host_reply!(text: 'Obrigado pela avaliação!')

      # act
      login_as guest
      visit reservation_path(reservation)

      # assert
      expect(page).not_to have_link 'Avalie sua estadia', href: new_reservation_review_path(reservation)
      expect(page).to have_content 'Resposta do anfitrião: Obrigado pela avaliação!'
    end
  end
end