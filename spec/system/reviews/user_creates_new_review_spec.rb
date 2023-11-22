require 'rails_helper'

describe 'User creates a new review' do
  it 'only when authenticated' do
    # arrange
    foo_reservation_id = 198237198
    # act
    visit new_reservation_review_path(foo_reservation_id)

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'from the homepage' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)
    guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                         role: :regular)
                         
    inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})

    room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    reservation = room.reservations.create!(start_date: 10.days.from_now,
                                              end_date: 20.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    # act
    login_as guest
    visit root_path
    click_on 'Minhas Reservas'
    click_on 'Reserva ABC00001'
    click_on 'Avalie sua estadia'

    # assert
    expect(page).to have_content 'Nova avaliação - Reserva ABC00001'
    expect(page).to have_content 'Albergue do Billy - Quarto El Dormitorio'
    start_date = 10.days.from_now.to_date
    end_date = 20.days.from_now.to_date
    expect(page).to have_content "Entre #{I18n.l(start_date)} e #{I18n.l(end_date)}"

    expect(page).to have_field 'Nota'
    expect(page).to have_content 'Escolha uma nota entre 0 (péssima) e 5 (ótima)'
    expect(page).to have_field 'Comentário'
    expect(page).to have_button 'Criar Avaliação'
  end

  it 'sucessfully' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)
    guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                         role: :regular)
                         
    inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})

    room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    reservation = room.reservations.create!(start_date: 10.days.from_now,
                                              end_date: 20.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    # act
    login_as guest
    visit new_reservation_review_path(reservation)
    select '5', from: 'Nota'
    fill_in 'Comentário', with: 'Pousada muito boa, com um toque castelhano.'
    click_on 'Criar Avaliação'

    # assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Sua avaliação foi criada com sucesso'
    expect(page).to have_content 'Sua nota para estadia: 5'
    comment = 'Seu comentário sobre a estadia: Pousada muito boa, com um toque castelhano.'
    expect(page).to have_content comment
  end

  it 'but fails if does not leave a comment' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)
    guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                         role: :regular)
                         
    inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})

    room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    reservation = room.reservations.create!(start_date: 10.days.from_now,
                                              end_date: 20.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    # act
    login_as guest
    visit new_reservation_review_path(reservation)
    fill_in 'Comentário', with: ''
    click_on 'Criar Avaliação'

    # assert
    expect(page).to have_content 'Não foi possível criar sua avaliação'
    expect(page).to have_content 'Comentário não pode ficar em branco'
    expect(page).to have_field 'Nota'
    expect(page).to have_content 'Escolha uma nota entre 0 (péssima) e 5 (ótima)'
    expect(page).to have_field 'Comentário'
    expect(page).to have_button 'Criar Avaliação'
  end

  context 'before checkout' do
    it 'but fails to see the link in the reservation page' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :host)
      guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                          role: :regular)
                          
      inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'})

      room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                                max_capacity: 5, rent_price: 50, status: :active)
      
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
      reservation = room.reservations.create!(start_date: 10.days.from_now,
                                                end_date: 20.days.from_now,
                                                number_guests: '2',
                                                status: 'active',
                                                user: guest)

      # act
      login_as guest
      visit reservation_path(reservation)

      # assert
      expect(page).not_to have_link 'Avalie sua estadia', 
        href: new_reservation_review_path(reservation)
    end

    it 'but fails and is redirected if tries to brute force through url' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :host)
      guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                          role: :regular)
                          
      inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'})

      room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                                max_capacity: 5, rent_price: 50, status: :active)
      
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
      reservation = room.reservations.create!(start_date: 10.days.from_now,
                                                end_date: 20.days.from_now,
                                                number_guests: '2',
                                                status: 'active',
                                                user: guest)

      # act
      login_as guest
      visit new_reservation_review_path(reservation)

      # assert
      expect(current_path).to eq reservation_path(reservation)
      expect(page).to have_content 'Você não pode criar uma nova avaliação para essa estadia.'
    end
  end

  it 'only for his/her reservation' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                          role: :host)
    guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                        role: :regular)
                        
    inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'})

    room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                              max_capacity: 5, rent_price: 50, status: :active)
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
    reservation = room.reservations.create!(start_date: 10.days.from_now,
                                              end_date: 20.days.from_now,
                                              number_guests: '2',
                                              status: 'finished',
                                              user: guest)

    # act
    login_as user
    visit new_reservation_review_path(reservation)

    # assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui autorização para essa ação.'
  end

  context 'for an extra time' do
    it 'but fails to see the link in the reservation page' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :host)
      guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                          role: :regular)
                          
      inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'})

      room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                                max_capacity: 5, rent_price: 50, status: :active)
      
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
      reservation = room.reservations.create!(start_date: 10.days.from_now,
                                                end_date: 20.days.from_now,
                                                number_guests: '2',
                                                status: 'finished',
                                                user: guest)

      reservation.create_review!(rating: 5, comment: 'Muito bom!')

      # act
      login_as guest
      visit reservation_path(reservation)

      # assert
      expect(page).not_to have_link 'Avalie sua estadia', 
        href: new_reservation_review_path(reservation)
    end

    it 'but fails and is redirected if tries to brute force through url' do
      # arrange
      user = User.create!(email: 'test@gmail.com', password: 'password', 
                            role: :host)
      guest = User.create!(email: 'reginaldo@rossi.com', password: 'garçom123',
                          role: :regular)
                          
      inn = user.create_inn!(brand_name: 'Albergue do Billy', 
                            registration_number: '58277983000198', 
                            phone_number: '(11) 976834383', checkin_time: '18:00',
                            checkout_time: '11:00', address_attributes: {
                              street_name: 'Av. da Pousada', number: '10', 
                              neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                              state: 'SP', zip_code: '05616-090'})

      room = inn.rooms.create!(name: 'El Dormitorio', description: 'Nice', area: 10,
                                max_capacity: 5, rent_price: 50, status: :active)
      
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABC00001')
      reservation = room.reservations.create!(start_date: 10.days.from_now,
                                                end_date: 20.days.from_now,
                                                number_guests: '2',
                                                status: 'active',
                                                user: guest)

      reservation.create_review!(rating: 5, comment: 'Muito bom!')

      # act
      login_as guest
      visit new_reservation_review_path(reservation)

      # assert
      expect(current_path).to eq reservation_path(reservation)
      expect(page).to have_content 'Você não pode criar uma nova avaliação para essa estadia.'
    end
  end 
end
