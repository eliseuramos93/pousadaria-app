require 'rails_helper'

describe 'User creates a new room for an inn' do
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

    # act
    visit create_new_room_path

    # assert
    expect(current_path).to eq new_user_session_path
  end

  # it 'only for a inn which the user is the host' do 
  #   # arrange
  #   user = User.create!(email: 'test@gmail.com', password: 'password', 
  #                       role: :host)
  #   another_user = User.create!(email: 'test2@gmail.com', password: 'password',
  #                               role: :host)
  #   inn = user.create_inn!(brand_name: 'Pousada Teste', 
  #                     registration_number: '58277983000198', 
  #                     phone_number: '(11) 976834383', checkin_time: '18:00',
  #                     checkout_time: '11:00', address_attributes: {
  #                       street_name: 'Av. da Pousada', number: '10', 
  #                       neighborhood: 'Bairro da Pousada', city: 'São Paulo',
  #                       state: 'SP', zip_code: '05616-090'})
  #   another_user.create_inn!(brand_name: 'Pousada Teste 2', 
  #                       registration_number: '582779834230198', 
  #                       phone_number: '(11) 564651321', checkin_time: '18:00',
  #                       checkout_time: '11:00', address_attributes: {
  #                         street_name: 'Av. da Pousada', number: '10', 
  #                         neighborhood: 'Bairro da Pousada', city: 'São Paulo',
  #                         state: 'SP', zip_code: '05616-090'})

  #   # act
  #   login_as another_user
  #   visit new_inn_room_path(inn.id)

  #   # assert
  #   expect(page).to have_content 'Você não possui autorização para essa ação.'
  #   expect(current_path).to eq root_path
  # end

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

    # act
    login_as user
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Adicionar Quarto'

    # assert
    expect(current_path).to eq create_new_room_path
    expect(page).to have_field 'Nome do Quarto'
    expect(page).to have_field 'Descrição do Quarto'
    expect(page).to have_field 'Área do Quarto (m²)'
    expect(page).to have_field 'Máximo de Hóspedes'
    expect(page).to have_field 'Valor da Diária'
    
    expect(page).to have_content 'Comodidades do Quarto'
    expect(page).to have_unchecked_field 'Banheiro próprio'
    expect(page).to have_unchecked_field 'Varanda'
    expect(page).to have_unchecked_field 'Ar condicionado'
    expect(page).to have_unchecked_field 'TV'
    expect(page).to have_unchecked_field 'Guarda-roupas'
    expect(page).to have_unchecked_field 'Cofre'
    expect(page).to have_unchecked_field 'Quarto acessível para PCD'

    expect(page).to have_content 'Disponibilidade do Quarto'
    expect(page).to have_field 'Marcar Quarto como Disponível'

    expect(page).to have_button 'Criar Quarto'
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

    # act
    login_as user
    visit create_new_room_path

    fill_in 'Nome do Quarto', with: 'The Legend of Zelda'
    fill_in 'Descrição do Quarto', with: 'Um quarto baseado na melhor franquia dos games!'
    fill_in 'Área do Quarto (m²)', with: '40'
    fill_in 'Máximo de Hóspedes', with: '3'
    fill_in 'Valor da Diária', with: '200'

    check 'Banheiro próprio'
    check 'Varanda'
    check 'Ar condicionado'
    check 'TV'
    check 'Guarda-roupas'
    check 'Cofre'
    check 'Quarto acessível para PCD'

    check 'Marcar Quarto como Disponível'
    click_on 'Criar Quarto'

    # assert
    expect(current_path).to eq inn_room_path(inn.id, inn.rooms.first.id)
    expect(page).to have_content 'Quarto criado com sucesso'
    expect(page).to have_content 'Quarto The Legend of Zelda'
    expect(page).to have_content 'Quarto disponível para reservas'
    expect(page).to have_content 'Um quarto baseado na melhor franquia dos games!'
    expect(page).to have_content 'Área: 40 m²'
    expect(page).to have_content 'Capacidade: 3 pessoas'
    expect(page).to have_content 'Valor da Diária: R$ 200,00'
    expect(page).to have_content 'Possui banheiro próprio'
    expect(page).to have_content 'Possui varanda'
    expect(page).to have_content 'Possui ar condicionado'
    expect(page).to have_content 'Possui TV'
    expect(page).to have_content 'Possui guarda-roupas'
    expect(page).to have_content 'Possui cofre'
    expect(page).to have_content 'Quarto projetado com acessibilidade'
  end

  it 'only if filling all of the mandatory fields' do
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

    # act
    login_as user
    visit create_new_room_path

    fill_in 'Nome do Quarto', with: ''
    fill_in 'Descrição do Quarto', with: ''
    fill_in 'Área do Quarto (m²)', with: ''
    fill_in 'Máximo de Hóspedes', with: ''
    fill_in 'Valor da Diária', with: ''
    click_on 'Criar Quarto'

    # assert
    expect(page).to have_content 'Não foi possível criar novo quarto'
    expect(page).to have_content 'Nome do Quarto não pode ficar em branco'
    expect(page).to have_content 'Descrição do Quarto não pode ficar em branco'
    expect(page).to have_content 'Área do Quarto (m²) não pode ficar em branco'
    expect(page).to have_content 'Máximo de Hóspedes não pode ficar em branco'
    expect(page).to have_content 'Valor da Diária não pode ficar em branco'
  end
end