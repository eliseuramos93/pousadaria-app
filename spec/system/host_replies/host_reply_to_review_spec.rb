require 'rails_helper'

describe 'Host replies to a review' do
  it 'only when authenticated' do
    # arrange

    # act
    visit new_review_host_reply_path(198230918039)

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'starting from the inn reviews list page' do
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


    # act
    login_as host
    visit my_inn_reviews_path
    click_on 'Responder avaliação'

    # assert
    expect(current_path).to eq new_review_host_reply_path(review)
    expect(page).to have_content 'Responder a avaliação da reserva ABC00001'
    expect(page).to have_content 'Hóspede: Reginaldo Rossi'
    expect(page).to have_content 'Quarto: El Dormitorio'
    start_date = 5.days.from_now.to_date
    end_date = 9.days.from_now.to_date
    expect(page).to have_content "Período: #{I18n.l(start_date)} - #{I18n.l(end_date)}"
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Comentário: Muito bom!'

    expect(page).to have_field 'Texto da resposta'
    expect(page).to have_button 'Criar Resposta'
  end

  it 'successfully' do
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


    # act
    login_as host
    visit new_review_host_reply_path(review)
    
    fill_in 'Texto da resposta', with: 'Obrigado pela sua avaliação! :)'
    click_on 'Criar Resposta'

    # assert
    expect(current_path).to eq my_inn_reviews_path
    expect(page).to have_content 'Sua resposta foi criada com sucesso'
    expect(page).to have_content 'Sua resposta: Obrigado pela sua avaliação! :)'
    expect(page).not_to have_link 'Responder avaliação', href: new_review_host_reply_path(review)
  end
end