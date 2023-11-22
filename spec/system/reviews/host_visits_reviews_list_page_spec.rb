require 'rails_helper'

describe 'Host visits the reviews list page' do
  it 'only when authenticated' do
    # arrange

    # act
    visit my_inn_reviews_path

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'from any page through the navigation bar' do
    # arrange
    host = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)
    guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                        role: :regular)
                        
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
    reservation_a = room.reservations.create!(start_date: 5.days.from_now,
                                              end_date: 9.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    reservation_a.create_review!(rating: 5, comment: 'Muito bom!')

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00002')
    reservation_b = room.reservations.create!(start_date: 10.days.from_now,
                                              end_date: 20.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    reservation_b.create_review!(rating: 1, comment: 'Não foi tão bom assim!')

    # act
    login_as host
    visit root_path
    within '#nav-links' do
      click_on 'Avaliações'
    end

    # assert
    expect(current_path).to eq my_inn_reviews_path
    expect(page).to have_content 'Avaliações - Albergue do Billy'
    expect(page).to have_content 'Reserva ABC00001'
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Comentário: Muito bom!'
    expect(page).to have_content 'Reserva ABC00002'
    expect(page).to have_content 'Nota: 1'
    expect(page).to have_content 'Comentário: Não foi tão bom assim!'
  end
end