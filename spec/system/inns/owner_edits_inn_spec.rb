require 'rails_helper'

describe 'User visits inn edit page' do
  it 'from the inn details page' do
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
    visit inn_path(inn.id)
    click_on 'Editar Pousada'

    # assert
    expect(page).to have_field 'Nome fantasia'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Telefone'
    expect(page).to have_field 'Logradouro'
    expect(page).to have_field 'Número'
    expect(page).to have_field 'Complemento'
    expect(page).to have_field 'Bairro'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'
    expect(page).to have_field 'CEP'
    expect(page).to have_field 'Horário de check-in'
    expect(page).to have_field 'Horário de check-out'
    expect(page).to have_button 'Atualizar Pousada'
  end

  it 'and only sees the edit button for an inn they own' do
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
    expect(page).not_to have_link 'Editar Pousada', href: edit_inn_path(teddy_inn.id)
  end

  it 'and is not allowed to remove any of the mandatory fields' do
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

    # act
    login_as billy
    visit inn_path(billy_inn.id)
    click_on 'Editar Pousada'

    fill_in 'Nome fantasia', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Telefone', with: ''

    fill_in 'Logradouro', with: ''
    fill_in 'Número', with: ''
    fill_in 'Complemento', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: ''
    fill_in 'CEP', with: ''

    fill_in 'Horário de check-in', with: ''
    fill_in 'Horário de check-out', with: ''
    click_on 'Atualizar Pousada'

    # assert
    expect(page).to have_content 'Nome fantasia não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'Logradouro não pode ficar em branco'
    expect(page).to have_content 'Número não pode ficar em branco'
    expect(page).not_to have_content 'Complemento não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
    expect(page).to have_content 'Horário de check-in não pode ficar em branco'
    expect(page).to have_content 'Horário de check-out não pode ficar em branco'
    expect(page).to have_content 'Não foi possível atualizar sua pousada.'
  end
end