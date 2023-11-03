require 'rails_helper'

describe 'Host creates a seasonal rate for a room' do
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

    # act
    visit new_inn_room_seasonal_rate_path(inn.id, room.id)

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'starting from the homepage' do
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

    # act
    login_as user
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Quarto'
    click_on 'Adicionar Preço de Temporada'

    # assert
    expect(current_path).to eq new_inn_room_seasonal_rate_path(inn.id, room.id)
    expect(page).to have_field 'Data de início'
    expect(page).to have_field 'Data de término'
    expect(page).to have_field 'Preço de temporada'
    expect(page).to have_button 'Criar Preço de Temporada'
  end

  context 'of another host, using inn_id and room_id that do not belong to him/her' do
    it 'and is redirected to homepage' do
      # arrange
      billy = User.create!(email: 'billy@mail.com', password: 'password',
                          role: :host)
      billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                  registration_number: '94466613000162',
                                  phone_number: '(11) 98765-4321',
                                  checkin_time: '20:00', checkout_time: '12:00',
                                  address_attributes: {street_name: 'Rua do Billy',
                                  number: '10', neighborhood: 'ABC',
                                  city: 'Mongaguá', state: 'SP',
                                  zip_code: '16000-000'})
      room_a = billy_inn.rooms.create!(name: 'Quarto', description: 'Nice', 
                                        area: 10, max_capacity: 2, rent_price: 50,
                                        status: :active)

      teddy = User.create!(email: 'teddy@mail.com', password: 'password', 
                          role: :host)
      teddy_inn = teddy.create_inn!(brand_name: 'Pousada do Teddy', 
                                  registration_number: '1209380192830',
                                  phone_number: '(11) 98765-1234',
                                  checkin_time: '20:00', checkout_time: '12:00',
                                  address_attributes: {street_name: 'Alameda do Teddy',
                                  number: '20', neighborhood: 'ABC',
                                  city: 'Mongaguá', state: 'SP',
                                  zip_code: '16000-000'})
      room_b = teddy_inn.rooms.create!(name: 'Quarto', description: 'Nice', 
                                      area: 10, max_capacity: 2, rent_price: 50, 
                                      status: :active)

      # act
      login_as teddy
      visit new_inn_room_seasonal_rate_path(billy_inn.id, room_a.id)

      # assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não possui autorização para essa ação.'
    end
  end

  context 'of another host, using a proper inn_id but a room_id that do not belong to him/her' do
    it 'and is redirected to homepage' do
      # arrange
      billy = User.create!(email: 'billy@mail.com', password: 'password',
                          role: :host)
      billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                  registration_number: '94466613000162',
                                  phone_number: '(11) 98765-4321',
                                  checkin_time: '20:00', checkout_time: '12:00',
                                  address_attributes: {street_name: 'Rua do Billy',
                                  number: '10', neighborhood: 'ABC',
                                  city: 'Mongaguá', state: 'SP',
                                  zip_code: '16000-000'})
      room_a = billy_inn.rooms.create!(name: 'Quarto', description: 'Nice', 
                                        area: 10, max_capacity: 2, rent_price: 50,
                                        status: :active)

      teddy = User.create!(email: 'teddy@mail.com', password: 'password', 
                          role: :host)
      teddy_inn = teddy.create_inn!(brand_name: 'Pousada do Teddy', 
                                  registration_number: '1209380192830',
                                  phone_number: '(11) 98765-1234',
                                  checkin_time: '20:00', checkout_time: '12:00',
                                  address_attributes: {street_name: 'Alameda do Teddy',
                                  number: '20', neighborhood: 'ABC',
                                  city: 'Mongaguá', state: 'SP',
                                  zip_code: '16000-000'})
      room_b = teddy_inn.rooms.create!(name: 'Quarto', description: 'Nice', 
                                      area: 10, max_capacity: 2, rent_price: 50, 
                                      status: :active)

      # act
      login_as teddy
      visit new_inn_room_seasonal_rate_path(teddy_inn.id, room_a.id)

      # assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Essa página não existe'
    end
  end

  it 'successfully' do
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

    # act
    login_as user
    visit new_inn_room_seasonal_rate_path(inn.id, room.id)
    fill_in 'Data de início', with: 10.days.from_now
    fill_in 'Data de término', with: 20.days.from_now
    fill_in 'Preço de temporada', with: '74.99'
    click_on 'Criar Preço de Temporada'

    # assert
    expect(current_path).to eq inn_room_path(inn.id, room.id)
    expect(page).to have_content 'Preço de Temporada criado com sucesso'
    expect(page).to have_content 'Preços Diferenciados para Quarto'
    start_date = I18n.localize 10.days.from_now.to_date
    end_date = I18n.localize 20.days.from_now.to_date
    expect(page).to have_content "Entre #{start_date} e #{end_date}: R$ 74,99"
  end

  it 'only by filling all of the mandatory fields' do
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

    # act
    login_as user
    visit new_inn_room_seasonal_rate_path(inn.id, room.id)
    fill_in 'Data de início', with: ''
    fill_in 'Data de término', with: ''
    fill_in 'Preço de temporada', with: ''
    click_on 'Criar Preço de Temporada'

    # assert
    expect(page).to have_content 'Não foi possível criar novo preço de temporada'
    expect(page).to have_content 'Data de início não pode ficar em branco'
    expect(page).to have_content 'Data de término não pode ficar em branco'
    expect(page).to have_content 'Preço de temporada não pode ficar em branco'
  end

  it 'but fails by informing a past start date' do 
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

    # act
    login_as user
    visit new_inn_room_seasonal_rate_path(inn.id, room.id)
    fill_in 'Data de início', with: 1.day.ago
    fill_in 'Data de término', with: 1.day.from_now
    fill_in 'Preço de temporada', with: '199.99'
    click_on 'Criar Preço de Temporada'

    # assert
    expect(page).to have_content 'Não foi possível criar novo preço de temporada'
    expect(page).to have_content 'Data de início não pode ser no passado'
  end

  it "that doesn't overlap with already existent seasonal rate" do
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

    rate = room.seasonal_rates.create!(start_date: 10.days.from_now,
                                       end_date: 20.days.from_now,
                                       price: '69.99')

    # act
    login_as user
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Quarto de Aluguel'
    click_on 'Adicionar Preço de Temporada'

    fill_in 'Data de início', with: 5.days.from_now
    fill_in 'Data de término', with: 15.days.from_now
    fill_in 'Preço de temporada', with: '99.99'
    click_on 'Criar Preço de Temporada'

    # assert
    expect(page).to have_content 'Não foi possível criar novo preço de temporada'
    expect(page).to have_content 'Preço de Temporada não pode ter conflito de datas com outros Preços de Temporadas'
  end
end