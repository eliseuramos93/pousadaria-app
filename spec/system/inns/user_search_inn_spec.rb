require 'rails_helper'

describe 'User searches for an inn' do
  it 'from the navigation bar' do
    # arrange
  
    # act
    visit root_path

    # assert
    within 'nav' do
      expect(page).to have_field('Procurar Pousada')
      expect(page).to have_button('Buscar')
    end
  end

  it 'and finds three inns' do
    # arrange
    user_a = User.create!(email: 'andre@gmail.com', password: 'password', 
                      role: 'host')
    user_b = User.create!(email: 'bento@gmail.com', password: 'password', 
                      role: 'host')
    user_c = User.create!(email: 'celso@gmail.com', password: 'password', 
                      role: 'host')
    user_d = User.create!(email: 'diego@gmail.com', password: 'password',
                      role: 'host')

    inn_a = user_a.create_inn!(brand_name: "Pousada do André", 
                              registration_number: '12345612318', 
                              phone_number: '(11) 109238019', 
                              checkin_time: '19:00', checkout_time: '12:00',
                              address_attributes: {
                                street_name: 'Av. Angelica', number: '1',
                                neighborhood: 'Bairro A', city: 'São Paulo',
                                state: 'SP', zip_code: '01000-000' },
                              status: 'active')
    inn_b = user_b.create_inn!(brand_name: "Bento torce pro São Paulo", 
                               registration_number: '18273981731', 
                               phone_number: '(11) 189237189', 
                               checkin_time: '20:00', checkout_time: '11:00',
                               address_attributes: {
                                  street_name: 'R. Birigui', number: '12',
                                  neighborhood: 'Bairro B', city: 'Barueri',
                                  state: 'SP', zip_code: '02000-000' },
                               status: 'active')
    inn_c = user_c.create_inn!(brand_name: "Canto do Celso", 
                               registration_number: '18273981731', 
                               phone_number: '(11) 189237189', 
                               checkin_time: '20:00', checkout_time: '11:00',
                               address_attributes: {
                                  street_name: 'R. Cubatão', number: '33',
                                  neighborhood: 'São Paulo', city: 'Birigui',
                                  state: 'SP', zip_code: '03000-000' },
                               status: 'active')
    inn_d = user_d.create_inn!(brand_name: "Divino do Diego", 
                                registration_number: '1827398172398', 
                                phone_number: '(11) 189273891', 
                                checkin_time: '18:00', checkout_time: '10:00',
                                address_attributes: {
                                   street_name: 'R. Dourados', number: '45',
                                   neighborhood: 'Bairro D', city: 'Peruibe',
                                   state: 'SP', zip_code: '04000-000' },
                                status: 'active')

    # act
    visit root_path
    fill_in 'Procurar Pousada', with: 'São Paulo'
    click_on 'Buscar Pousada'

    # assert
    expect(page).to have_content 'Resultados de pesquisa por São Paulo'
    expect(page).to have_content '3 pousadas'
    expect(page).to have_link 'Pousada do André', href: inn_path(inn_a)
    expect(page).to have_link 'Bento torce pro São Paulo', href: inn_path(inn_b)
    expect(page).to have_link 'Canto do Celso', href: inn_path(inn_c)
    expect(page).not_to have_link 'Divino do Diego', href: inn_path(inn_d)
  end

  it 'but has zero returns' do
    # arrange
    user_a = User.create!(email: 'andre@gmail.com', password: 'password', 
                      role: 'host')

    inn_a = user_a.create_inn!(brand_name: "Pousada do André", 
                              registration_number: '12345612318', 
                              phone_number: '(11) 109238019', 
                              checkin_time: '19:00', checkout_time: '12:00',
                              address_attributes: {
                                street_name: 'Av. Angelica', number: '1',
                                neighborhood: 'Bairro A', city: 'São Paulo',
                                state: 'SP', zip_code: '01000-000' },
                              status: 'active')

    # act
    visit root_path
    fill_in 'Procurar Pousada', with: 'Rio de Janeiro'
    click_on 'Buscar Pousada'

    # assert
    expect(page).not_to have_content '0 pousadas'
    expect(page).to have_content 'Não foram encontrados resultados para Rio de Janeiro'
  end
end