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

  it 'sucessfully' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    another_user = User.create!(email: 'guest@gmail.com', password: 'password',
                                role: 'regular', first_name: 'Billy',
                                last_name: 'Pampers', 
                                personal_id_number: '12345678900') 

    inn = user.create_inn!(brand_name: 'Pousadinha do Teste', 
                           registration_number: '58277983000198', 
                           phone_number: '(11) 976834383', checkin_time: '18:00',
                           checkout_time: '11:00', address_attributes: {
                             street_name: 'Av. da Pousada', number: '10', 
                             neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                             state: 'SP', zip_code: '05616-090'}, 
                           status: 'active')

    room = inn.rooms.create!(name: 'El Testón', description: 'Nice', area: 10,
                             max_capacity: 4, rent_price: 50, status: :active)

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 20.days.from_now,
                                       price: '100')
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')

    # act
    login_as another_user
    visit root_path
    click_on "Pousadinha do Teste"
    click_on 'El Testón'
    click_on 'Reservar'

    fill_in 'Data de check-in', with: 7.days.from_now
    fill_in 'Data de checkout', with: 13.days.from_now
    fill_in 'Número de hóspedes', with: '3'
    click_on 'Continuar com Reserva'

    click_on 'Confirmar Reserva'

    # assert
    expect(page).to have_content 'Sua reserva foi criada com sucesso!'
    expect(page).to have_content 'Minhas Reservas'
    expect(page).to have_content 'Pousada: Pousadinha do Teste'
    expect(page).to have_content 'Quarto El Testón'
    start_date = I18n.localize 7.days.from_now.to_date
    end_date = I18n.localize 13.days.from_now.to_date
    expect(page).to have_content "Check-in: #{start_date} - 18:00"
    expect(page).to have_content "Check-out: #{end_date} - 11:00"
    expect(page).to have_content 'Valor: R$ 500,00'
    expect(page).to have_link 'Reserva ABC12345', href: reservation_path(Reservation.first)
  end
end