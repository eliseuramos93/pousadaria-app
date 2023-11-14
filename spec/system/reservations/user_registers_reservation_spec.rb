require 'rails_helper'

describe 'User concludes the reservation process' do
  it 'only when authenticated' do
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

    click_on 'Confirmar Reserva'

    # assert
    expect(current_path).to eq new_user_session_path
  end

  pending 'sucessfully'

  # user signs up
  # user signs in
  # user returns to confirm_reservation_path
    # page must display:
      # checkin date and time
      # checkout date and time
      # chosen room
      # total amount for reservation
      # list of payment methods
      # button to confirm reservation
  # user clicks on the confirm reservation button
  # reservation must have an 8 random characters unique code
end