require 'rails_helper'

describe "Host visits the list of his/hers inn's seasonal rates" do
  it 'only when authenticated' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)

    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})

    room = inn.rooms.create!(name: 'Quarto', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 11.days.from_now,
                                       price: '60.99')

    # act
    visit inn_room_seasonal_rates_path(inn.id, room.id)

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'only to an inn that belongs to him/her' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    another_user = User.create!(email: 'billy@gmail.com', password: 'testpass',
                                role: :host)

    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    another_user.create_inn!(brand_name: 'Outra Pousada Teste', 
                              registration_number: '58277983000198', 
                              phone_number: '(11) 976834383', 
                              checkin_time: '18:00', checkout_time: '11:00', 
                              address_attributes: {
                                street_name: 'Av. da Pousada', number: '10', 
                                neighborhood: 'Bairro da Pousada', 
                                city: 'São Paulo', state: 'SP', 
                                zip_code: '05616-090'})

    room = inn.rooms.create!(name: 'Bedroom', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 11.days.from_now,
                                       price: '60.99')

    # act
    login_as another_user
    visit inn_room_seasonal_rates_path(inn.id, room.id)

    # assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui autorização para essa ação.'
  end

  it 'from the homepage' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)

    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})

    room = inn.rooms.create!(name: 'Quarto de Aluguel', description: 'Nice', area: 10,
                             max_capacity: 2, rent_price: 50, status: :active)

    rate_1 = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 20.days.from_now,
                                       price: '69.99')
    rate_2 = room.seasonal_rates.create!(start_date: 21.days.from_now,
                                       end_date: 31.days.from_now,
                                       price: '29.99')

    # act
    login_as user
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Quarto de Aluguel'
    click_on 'Ver meus Preços de Temporada para este quarto'

    # assert
    expect(current_path).to eq inn_room_seasonal_rates_path(inn.id, room.id)
    expect(page).to have_content 'Meus Preços de Temporada para Quarto de Aluguel'
    start_date_1 = I18n.localize 10.days.from_now.to_date
    end_date_1 = I18n.localize 20.days.from_now.to_date
    start_date_2 = I18n.localize 21.days.from_now.to_date
    end_date_2 = I18n.localize 31.days.from_now.to_date
    expect(page).to have_content "Entre #{start_date_1} e #{end_date_1}: R$ 69,99"
    expect(page).to have_content "Entre #{start_date_2} e #{end_date_2}: R$ 29,99"
  end
end