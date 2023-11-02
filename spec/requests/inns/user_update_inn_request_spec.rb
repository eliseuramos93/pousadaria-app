require 'rails_helper'

describe 'User requests to update an inn' do
  it 'but must be authenticated' do
    # arrange
    foobar_inn_id = 128390128   # mashed the numpad for a random number

    # act
    patch inn_path(foobar_inn_id, inn: {brand_name: 'asdoaidsjioa'})

    # assert
    expect(response).to redirect_to new_user_session_path
  end

  it 'but is not authorized due to being a regular user' do
    # arrange
      # create user as regular to force an impossible scenario through rails,
      # but possible through direct input in database.
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :regular)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
              registration_number: '58277983000198', 
              phone_number: '(11) 976834383', checkin_time: '18:00',
              checkout_time: '11:00', address_attributes: {
                street_name: 'Av. da Pousada', number: '10', 
                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                state: 'SP', zip_code: '05616-090'})

    # act
    login_as user
    patch inn_path(inn.id, inn:  {brand_name: 'foo bar inn'})

    # assert
      # prove that rails prevents a regular user to edit an inn, even if the 
      # user owns the inn in a "system breach"
    expect(response).to redirect_to root_path
  end

  it "but is not authorized due to not being the inn's host" do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :host)
    another_user = User.create!(email: 'billy@gmail.com', password: 'password',
                        role: :host)
    inn = user.create_inn!(brand_name: 'Pousada Teste', 
              registration_number: '58277983000198', 
              phone_number: '(11) 976834383', checkin_time: '18:00',
              checkout_time: '11:00', address_attributes: {
                street_name: 'Av. da Pousada', number: '10', 
                neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                state: 'SP', zip_code: '05616-090'})
    another_user.create_inn!(brand_name: 'Pousada Teste 2', 
                registration_number: '582779834230198', 
                phone_number: '(11) 564651321', checkin_time: '18:00',
                checkout_time: '11:00', address_attributes: {
                  street_name: 'Av. da Pousada', number: '10', 
                  neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                  state: 'SP', zip_code: '05616-090'})

    # act
    login_as another_user
    patch inn_path(inn.id, inn:  {brand_name: 'foo bar inn'})

    # assert
    expect(response).to redirect_to root_path
  end
end