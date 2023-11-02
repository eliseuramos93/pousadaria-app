require 'rails_helper'

describe 'Owner change the active status for the inn' do
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

  it 'only of his/hers owning' do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    teddy = User.create!(email: 'teddy@mail.com', password: 'password1')
    
    billy_inn = billy.build_inn(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00')
    billy_address = billy_inn.build_address(street_name: 'Rua do Billy',
                                            number: '10', neighborhood: 'ABC',
                                            city: 'Mongaguá', state: 'SP',
                                            zip_code: '16000-000')
    billy_inn.save

    teddy_inn = teddy.build_inn(brand_name: 'Cantinho do Teddy', 
      registration_number: '01277958000197',
      phone_number: '(11) 87654-3210',
      checkin_time: '18:00', checkout_time: '11:00')
    teddy_address = teddy_inn.build_address(street_name: 'Rua do Teddy',
                      number: '20', neighborhood: 'DEF',
                      city: 'Mongaguá', state: 'SP',
                      zip_code: '16100-000')
    teddy_inn.save

    # act
    login_as billy
    visit inn_path(teddy_inn.id)

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