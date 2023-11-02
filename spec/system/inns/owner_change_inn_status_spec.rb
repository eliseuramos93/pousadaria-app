require 'rails_helper'

describe 'Owner change the status for its own inn' do
  it 'only when authenticated' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password')
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'})
    
    # act
    visit inn_path(inn.id)

    # assert
    expect(page).not_to have_button 'Marcar Pousada como Disponível'
    expect(page).not_to have_button 'Marcar Pousada como Indisponível'
  end

  it 'from active to inactive' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'}, status: 'active')
    
    # act
    login_as user
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Marcar como Indisponível'

    # assert
    expect(page).to have_content 'Pousada Indisponível'
    expect(page).to have_button 'Marcar como Disponível'
  end

  it 'from inactive to active' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
                      registration_number: '58277983000198', 
                      phone_number: '(11) 976834383', checkin_time: '18:00',
                      checkout_time: '11:00', address_attributes: {
                        street_name: 'Av. da Pousada', number: '10', 
                        neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                        state: 'SP', zip_code: '05616-090'}, status: 'inactive')
    
    # act
    login_as user
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Marcar como Disponível'

    # assert
    expect(page).to have_content 'Pousada Disponível'
    expect(page).to have_button 'Marcar como Indisponível'
  end
end