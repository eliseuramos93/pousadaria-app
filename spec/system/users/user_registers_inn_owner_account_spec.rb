require 'rails_helper'

describe 'User creates an user account' do
  it 'from the homepage' do
    # arrange
    # act
    visit root_path
    click_on 'Criar uma conta'

    # assert
    expect(current_path).to eq new_user_registration_path
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'
    expect(page).to have_button 'Criar Conta'
  end

  it 'successfully' do
    # arrange

    # act
    visit root_path
    click_on 'Criar uma conta'

    fill_in 'E-mail', with: 'teste@gmail.com'
    fill_in 'Senha', with: 'senhaforte1234!'
    fill_in 'Confirme sua senha', with: 'senhaforte1234!'
    click_on 'Criar Conta'

    # assert
    expect(page).to have_content 'Boas vindas! Sua conta foi criada com sucesso.'
    within 'nav' do
      expect(page).to have_content 'teste@gmail.com'
    end
  end

  it 'only with an email address not already in use' do
    # arrange
    User.create!(email: 'teste@gmail.com', password: 'reginaldorossi')

    # act
    visit root_path
    click_on 'Criar uma conta'

    fill_in 'E-mail', with: 'teste@gmail.com'
    fill_in 'Senha', with: 'senhaforte1234!'
    fill_in 'Confirme sua senha', with: 'senhaforte1234!'
    click_on 'Criar Conta'
    
    # assert
    expect(page).to have_content 'E-mail já está em uso'
  end
end