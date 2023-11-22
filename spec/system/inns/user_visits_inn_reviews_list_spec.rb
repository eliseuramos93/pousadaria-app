require 'rails_helper'

describe 'User visits the inn reviews list page' do
  it 'and sees a list of all reviews the inn has' do
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
                            neighborhood: 'Bairro da Pousada', city: 'Piracicaba',
                            state: 'SP', zip_code: '05616-090'}, status: 'active')

    room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    reservation_a = room.reservations.create!(start_date: 1.days.from_now,
                                              end_date: 2.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00002')
    reservation_b = room.reservations.create!(start_date: 3.days.from_now,
                                              end_date: 4.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00003')
    reservation_c = room.reservations.create!(start_date: 5.days.from_now,
                                              end_date: 6.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00004')
    reservation_d = room.reservations.create!(start_date: 7.days.from_now,
                                              end_date: 9.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    review_a = reservation_a.create_review!(rating: 5, comment: 'Muito bom!')
    review_b = reservation_b.create_review!(rating: 4, comment: 'Bom!')
    review_c = reservation_c.create_review!(rating: 3, comment: 'Razoável')
    review_d = reservation_d.create_review!(rating: 3, comment: 'Meh...')

    review_d.create_host_reply!(text: 'Poderia nos explicar melhor o que deixou a desejar em sua estadia?')

    # act
    visit reviews_list_inn_path(inn)

    # assert
    expect(page).to have_content 'Avaliações - Albergue do Billy'
    expect(page).to have_content '4 comentários - Nota média: 3,75'
    expect(page).to have_content 'Reginaldo'
    expect(page).to have_content 'Meh...'
    expect(page).to have_content 'Razoável'
    expect(page).to have_content 'Bom!'
    expect(page).to have_content 'Muito bom!'
    expect(page).to have_content 'Resposta do anfitrião: Poderia nos explicar melhor o que deixou a desejar em sua estadia?'
  end
end
