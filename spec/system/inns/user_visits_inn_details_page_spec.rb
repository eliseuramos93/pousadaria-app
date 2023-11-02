require 'rails_helper'

describe 'User visits the inn details page' do
  it 'and sees the inn data' do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)

    # assert
    expect(page).to have_content 'Sobre Pousada do Billy'
    expect(page).to have_content 'Telefone para contato: (11) 98765-4321'
    expect(page).to have_content 'Horário de check-in: 20:00'
    expect(page).to have_content 'Horário de check-out: 12:00'
    expect(page).to have_content 'Endereço'
    expect(page).to have_content 'Rua do Billy, 10C'
    expect(page).to have_content 'ABC, Mongaguá - SP'
    expect(page).to have_content 'CEP: 16000-000'
  end

  it "and sees the policies for a pet friendly inn" do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                description: 'Linda pousada em frente à praia',
                                pet_friendly: true, 
                                policy: 'Não permitimos fumantes. Não permitimos festas.',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)

    # assert
  
    expect(page).to have_content 'Linda pousada em frente à praia'
    expect(page).to have_content 'Aceita animais de estimação'
    expect(page).to have_content 'Informações adicionais: Não permitimos fumantes. Não permitimos festas.'
  end

  it "and sees the policies for a non-pet friendly inn" do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                description: 'Linda pousada em frente à praia',
                                pet_friendly: false, 
                                policy: 'Não permitimos fumantes. Não permitimos festas.',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)

    # assert
  
    expect(page).to have_content 'Linda pousada em frente à praia'
    expect(page).to have_content 'Não aceita animais de estimação'
    expect(page).to have_content 'Informações adicionais: Não permitimos fumantes. Não permitimos festas.'
  end

  it 'and sees a warning for an inn without informed policies' do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)

    # assert
    expect(page).to have_content 'Ainda não foram informadas as políticas desse local.'
  end

  it "and doesn't see the edit inn button if not authenticated" do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})

    # act
    visit inn_path(billy_inn.id)

    # assert
    expect(page).not_to have_link 'Editar', href: edit_inn_path(billy_inn.id)
  end

  it 'and returns to homepage' do
    # arrange
    billy = User.create!(email: 'billy@mail.com', password: 'password')
    billy_inn = billy.create_inn!(brand_name: 'Pousada do Billy', 
                                registration_number: '94466613000162',
                                phone_number: '(11) 98765-4321',
                                checkin_time: '20:00', checkout_time: '12:00',
                                address_attributes: {street_name: 'Rua do Billy',
                                number: '10C', neighborhood: 'ABC',
                                city: 'Mongaguá', state: 'SP',
                                zip_code: '16000-000'})
    
    # act
    visit inn_path(billy_inn.id)
    click_on 'Pousadaria'

    # assert
    expect(current_path).to eq root_path
  end
end

describe 'User visits own inn details page' do
  it 'from any page through the navigation bar' do 
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
    login_as user
    visit root_path
    click_on 'Minha Pousada'

    # assert
    expect(current_path).to eq my_inn_path
    expect(page).to have_content inn.brand_name
    expect(page).to have_content inn.phone_number
    expect(page).to have_link 'Editar', href: edit_inn_path(inn.id)
  end

  it 'using the my_inn route only when authenticated' do
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
    visit my_inn_path

    # assert
    expect(current_path).to eq new_user_session_path
  end
end
