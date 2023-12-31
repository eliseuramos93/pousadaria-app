require 'rails_helper'

describe 'Host visits own inn details page' do
  it 'from any page through the navigation bar' do 
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

  it "and sees the owner's section" do
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

    # assert
    expect(page).to have_content 'Área do Proprietário'
    expect(page).to have_content 'Pousada Disponível'
    expect(page).to have_button 'Marcar como Indisponível'
    expect(page).to have_link 'Editar Pousada', href: edit_inn_path(inn)
    expect(page).to have_link 'Adicionar Quarto', href: new_inn_room_path(inn)
    expect(page).to have_link 'Ver Meus Quartos', href: inn_rooms_path(inn)
  end 
end