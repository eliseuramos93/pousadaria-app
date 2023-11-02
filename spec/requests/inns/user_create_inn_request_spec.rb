require 'rails_helper'

describe 'User requests to create an inn' do
  it 'but must be authenticated' do
    # arrange
    
    # act
    post inns_path(inn:  {brand_name: 'Pousada Teste', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'}})
    # assert
    expect(response).to redirect_to new_user_session_path
  end

  it 'but must be a host user to have authorization' do
    # arrange
    user = User.create!(email: 'test@gmail.com', password: 'password', 
                        role: :regular)

    # act
    login_as user
    post inns_path(inn:  {brand_name: 'Pousada Teste', 
                          registration_number: '58277983000198', 
                          phone_number: '(11) 976834383', checkin_time: '18:00',
                          checkout_time: '11:00', address_attributes: {
                            street_name: 'Av. da Pousada', number: '10', 
                            neighborhood: 'Bairro da Pousada', city: 'São Paulo',
                            state: 'SP', zip_code: '05616-090'}})

    # assert
    expect(response).to redirect_to root_path
  end
end