require 'rails_helper'

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

  pending 'and updates the price correctly'
end