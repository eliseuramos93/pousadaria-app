require 'rails_helper'

describe 'Host create an album for an inn' do
  it 'when authenticated' do
    # arrange

    # act
    visit new_inn_pictures_path

    # assert
    expect(current_path).to eq new_user_session_path 
  end

  it 'only if is a host user' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :regular)

    # act
    login_as user
    visit new_inn_pictures_path

    # assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui autorização para essa ação'
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
                        state: 'SP', zip_code: '05616-090'}, status: 'active')

    # act
    login_as user
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Adicionar Fotos'

    # assert
    expect(page).to have_content 'Adicionar fotos em Pousada Teste'
    expect(page).to have_content 'Formatos permitidos de imagem: JPEG e PNG'
    expect(page).to have_content 'As imagens devem ser relacionadas a sua pousada'
    expect(page).to have_field 'Fotos'
    expect(page).to have_button 'Enviar'
  end
  
  it 'sucessfully' do
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
    visit new_inn_pictures_path

    files = [Rails.root + "spec/resources/images/inn1.jpg", Rails.root + "spec/resources/images/inn2.jpg"]
    attach_file('Fotos', files)
    click_on 'Enviar'

    # assert
    expect(current_path).to eq inn_path(inn)
    expect(page).to have_content 'Suas fotos foram adicionadas com sucesso!'
    expect(page).to have_content 'Fotos'
    expect(page).to have_css('img[src*="inn2.jpg"]')
    expect(page).to have_css('img[src*="inn1.jpg"]')
  end

  it 'fails if the host uploads an invalid file' do
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
    visit new_inn_pictures_path

    files = [Rails.root + "spec/resources/pdfs/pdf1.pdf", Rails.root + "spec/resources/images/inn2.jpg"]
    attach_file('Fotos', files)
    click_on 'Enviar'

    # assert
    expect(page).to have_content 'Houve um erro no envio dos arquivos'
    expect(page).to have_content 'Um arquivo possui um formato não permitido. Envie fotos no formato .jpeg, .jpg ou .png'
    expect(page).to have_field 'Fotos'
  end
end