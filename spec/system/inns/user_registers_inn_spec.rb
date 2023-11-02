require 'rails_helper'

describe 'User visits the inn creation page' do
  it 'only if authenticated' do
    # arrange

    # act
    visit new_inn_path

    # assert
    expect(current_path).to eq new_user_session_path
  end

  it 'by being redirected after registration' do 
    # arrange

    # act
    visit root_path
    click_on 'Seja um Pousadeiro'

    fill_in 'E-mail', with: 'teste@gmail.com'
    fill_in 'Senha', with: 'senhaforte1234!'
    fill_in 'Confirme sua senha', with: 'senhaforte1234!'
    click_on 'Criar Conta'

    # assert
    expect(current_path).to eq new_inn_path
  end

  it "and sees the fields to input the inn's data" do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password')

    # act
    login_as user
    visit root_path 

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
    expect(page).to have_field 'Descrição da Pousada'
    expect(page).to have_no_checked_field 'Aceita animais de estimação'
    expect(page).to have_field 'Políticas da Pousada'
    expect(page).to have_field 'Horário de check-in'
    expect(page).to have_field 'Horário de check-out'
    expect(page).to have_button 'Criar Pousada'
  end

  it 'and sees the fields to input the accepted payment methods' do 
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password')

    # act
    login_as user
    visit root_path 

    # assert
    expect(page).to have_content 'Meios de pagamento'
    within '#pix' do 
      expect(page).to have_content 'PIX'
      expect(page).to have_content 'Aceita'
      expect(page).to have_content 'Não aceita'
    end
    within '#credit-card'do
      expect(page).to have_content 'Cartão de crédito'
      expect(page).to have_content 'Aceita'
      expect(page).to have_content 'Não aceita'
    end
    within '#debit-card' do
      expect(page).to have_content 'Cartão de débito'
      expect(page).to have_content 'Aceita'
      expect(page).to have_content 'Não aceita'
    end
    within '#cash' do
      expect(page).to have_content 'Dinheiro'
      expect(page).to have_content 'Aceita'
      expect(page).to have_content 'Não aceita'
    end
    within '#deposit' do 
      expect(page).to have_content 'Depósito bancário'
      expect(page).to have_content 'Aceita'
      expect(page).to have_content 'Não aceita'
    end
  end

  it "and can't visit homepage before registering an inn" do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password')
    
    # act
    login_as user
    visit root_path

    # assert
    expect(current_path).to eq new_inn_path
  end

  it 'but fails to create a inn with missing data for the inn' do 
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'passwordftw')
    
    # act
    login_as user
    visit root_path

    fill_in 'Nome fantasia', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Telefone', with: ''
    click_on 'Criar Pousada'

    # assert
    expect(page).to have_content 'Não foi possível concluir o registro da sua pousada.'
    expect(page).to have_content 'Nome fantasia não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
  end

  it 'but fails to create a inn without a valid address' do
    # arrange
    billy = User.create!(email: 'billy@gmail.com', password: 'password')

    # act
    login_as billy
    visit root_path

    fill_in 'Logradouro', with: ''
    fill_in 'Número', with: ''
    fill_in 'Complemento', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: ''
    fill_in 'CEP', with: ''
    click_on 'Criar Pousada'

    # assert
    expect(page).to have_content 'Não foi possível concluir o registro da sua pousada.'
    expect(page).to have_content 'Logradouro não pode ficar em branco'
    expect(page).to have_content 'Número não pode ficar em branco'
    expect(page).not_to have_content 'Complemento não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
  end

  it 'but fails to create a inn without both checkin and checkout times' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password')

    # act
    login_as user
    visit root_path

    fill_in 'Horário de check-in', with: ''
    fill_in 'Horário de check-out', with: ''
    click_on 'Criar Pousada'

    # assert
    expect(page).to have_content 'Não foi possível concluir o registro da sua pousada.'
    expect(page).to have_content 'Horário de check-in não pode ficar em branco'
    expect(page).to have_content 'Horário de check-out não pode ficar em branco'
  end

  it 'and creates an inn successfully' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password')

    # act
    login_as user
    visit root_path

    fill_in 'Nome fantasia', with: 'Pousada de Mongaguá'
    fill_in 'CNPJ', with: '68852396000139'
    fill_in 'Telefone', with: '(11) 98765-4321'

    fill_in 'Logradouro', with: 'Rua da Praia'
    fill_in 'Número', with: '10C'
    fill_in 'Complemento', with: 'Lote 12'
    fill_in 'Bairro', with: 'Balneário Itaoca'
    fill_in 'Cidade', with: 'Mongaguá'
    fill_in 'Estado', with: 'São Paulo'
    fill_in 'CEP', with: '12345-678'

    fill_in 'Horário de check-in', with: '18:00'
    fill_in 'Horário de check-out', with: '11:00'
    click_on 'Criar Pousada'

    # assert
    expect(page).to have_content 'Sua Pousada foi registrada com sucesso!'
  end
end