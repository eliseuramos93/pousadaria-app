require 'rails_helper'

describe 'User cancels an reservation' do
  it 'successfully if done at least 7 days before check-in' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)
    guest = User.create!(email: 'guest@gmail.com', password: 'password',
                        role: :regular)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                            max_capacity: 2, rent_price: 50, status: :active)
    reservation = room.reservations.create!(user: guest, 
                                            start_date: 10.day.from_now,
                                            end_date: 20.days.from_now,
                                            number_guests: '2',
                                            status: 'confirmed')

    # act
    login_as guest
    visit root_path
    click_on 'Minhas Reservas'
    click_on 'Cancelar Reserva de Bedroom'

    # assert
    expect(page).to have_content 'Sua reserva foi cancelada com sucesso!'
    expect(page).to have_content 'Status da reserva: Cancelada'
  end

  it 'without success if there is less than 7 days to check-in' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)
    guest = User.create!(email: 'guest@gmail.com', password: 'password',
                        role: :regular)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})
    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                            max_capacity: 2, rent_price: 50, status: :active)
    reservation = room.reservations.create!(user: guest, 
                                            start_date: 3.day.from_now,
                                            end_date: 5.days.from_now,
                                            number_guests: '2',
                                            status: 'confirmed')

    # act
    login_as guest
    visit root_path
    click_on 'Minhas Reservas'
    click_on 'Cancelar Reserva de Bedroom'

    # assert
    expect(page).to have_content 'Não é possível cancelar uma reserva a menos de 7 dias do check-in'
    expect(page).to have_content 'Status da reserva: Confirmada'
  end
end