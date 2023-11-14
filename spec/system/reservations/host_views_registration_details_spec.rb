require 'rails_helper'

describe 'Host visits a registration details page' do
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
end